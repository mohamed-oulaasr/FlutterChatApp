// ignore_for_file: curly_braces_in_flow_control_structures, slash_for_doc_comments

import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static late SharedPreferences sharedPreferences;

  /**
   * init
   */
  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /**
   * Get Data
   */
  static dynamic getData({
    required String key,
  })
  {
    return sharedPreferences.get(key);
  }

  /**
   * Save Data
   */
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async
  {
    if(value is String)
      return await sharedPreferences.setString(key, value);  // if value is String
    if(value is int)
      return await sharedPreferences.setInt(key, value);     // if value is int
    if(value is bool)
      return await sharedPreferences.setBool(key, value);    // if value is bool

    return await sharedPreferences.setDouble(key, value);    // if value is Double
  }

  /**
   * Remove Data
   */
  static Future<bool> removeData({
    required String key,
  }) async
  {
    return await sharedPreferences.remove(key);
  }


}