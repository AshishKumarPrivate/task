import 'package:demo_task/model/user_model.dart';
import 'package:demo_task/network_manager/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';




enum AlphabetSortOrderEnum { az, za, none }

class UserControllerProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<UserListModel> _users = [];
  List<UserListModel> get users => _filteredUsers;

  List<UserListModel> _filteredUsers = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;
  int page = 1;
  final int perPageResults = 20;
  String? genderFilter;
  String searchQueryStr = '';
  AlphabetSortOrderEnum sortingOrder = AlphabetSortOrderEnum.none;
  final ScrollController scrollController = ScrollController();

  UserControllerProvider() {
    fetchUserList();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        !_isLoading &&
        _error == null) {
      page++;
      fetchUserList(append: true);
    }
  }

  Future<void> fetchUserList({bool append = false, bool refresh = false}) async {
    if (refresh) {
      page = 1;
      _users.clear();
      _filteredUsers.clear();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchUsers(
        page: page,
        results: perPageResults,
        gender: genderFilter,
      );
      final newUsers = (response['results'] as List)
          .map((json) => UserListModel.fromJson(json))
          .toList();

      if (append || !refresh) {
        _users.addAll(newUsers);
      } else {
        _users = newUsers;
      }
      _applyFiltersAndSort();
    } on DioException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setGenderFilter(String? gender) {
    if (genderFilter != gender) {
      genderFilter = gender;
      fetchUserList(refresh: true);
    }
  }

  void setSearchQuery(String query) {
    searchQueryStr = query.toLowerCase();
    _applyFiltersAndSort();
  }

  void setUserSortingOrder(AlphabetSortOrderEnum order) {
    sortingOrder = order;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    _filteredUsers = _users.where((user) {
      final fullName = user.fullName.toLowerCase();
      final email = user.email.toLowerCase();
      return fullName.contains(searchQueryStr) || email.contains(searchQueryStr) ;
    }).toList();

    if (sortingOrder == AlphabetSortOrderEnum.az) {
      _filteredUsers.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else if (sortingOrder == AlphabetSortOrderEnum.za) {
      _filteredUsers.sort((a, b) => b.fullName.compareTo(a.fullName));
    }

    notifyListeners();
  }

  Future<void> refreshUsers() async {
    await fetchUserList(refresh: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}