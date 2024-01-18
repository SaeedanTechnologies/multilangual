import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';



class NextPage extends StatefulWidget {
  String selectedLanguage;
   String? token;
   Map<String, dynamic>? userData;
  NextPage({ required this.selectedLanguage,this.token,this.userData});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  TextEditingController searchController = TextEditingController();
  List<String> dataList = [];
 Map<String, dynamic> translations = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageButton(
              language: 'english',
              isSelected: widget.selectedLanguage == 'english',
              onPressed: () {
                setState(() {
                  widget.selectedLanguage = 'english';
                });
              },
            ),
            SizedBox(width: 16.w),
            LanguageButton(
              language: 'soomaali',
              isSelected: widget.selectedLanguage == 'soomaali',
              onPressed: () {
                setState(() {
                  widget.selectedLanguage = 'soomaali';
                });
              },
            ),
            SizedBox(width: 16.w),
            LanguageButton(
              language: 'arabic',
              isSelected: widget.selectedLanguage == 'arabic',
              onPressed: () {
                setState(() {
                  widget.selectedLanguage = 'arabic';
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
                 Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  
                  border: Border.all(width: 1.w,color: Color(0xFF832CE5
),),
                ),
                width: 299.w,
                height: 44.h,
                child: TextField(
                  
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              border: InputBorder.none,
             suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                
                    setState(() {
                          dataList.length = 0;
                    });
                    fetchExactTranslation(searchController.text, widget.selectedLanguage,widget.token!);
                  }
                },
              ),
              
            ),
            onTap: () {
             
              _fetchSuggestions(widget.selectedLanguage,widget.token!);
            },
          ),
              ),
          // TextField(
          //   controller: searchController,
          //   decoration: InputDecoration(
          //     labelText: 'Search',
          //    suffixIcon: IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {
          //         if (searchController.text.isNotEmpty) {
                
          //           setState(() {
          //                 dataList.length = 0;
          //           });
          //           fetchExactTranslation(searchController.text, widget.selectedLanguage,widget.token!);
          //         }
          //       },
          //     ),
              
          //   ),
          //   onTap: () {
             
          //     _fetchSuggestions(widget.selectedLanguage,widget.token!);
          //   },
          // ),
          SizedBox(height: 20.h),
          dataList.length != 0 ? 
          SingleChildScrollView(
            child: Container(
              height: 300,
              width: 500,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataList[index]),
                      onTap: () {
                    _getTranslation(dataList[index], widget.selectedLanguage);
                  },
                  );
                },
              ),
            ),
          )
          :
          Container()
          ,
            //  if (translations.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width /2,
                padding: EdgeInsets.all(16),
                color: Color(0xFFB4ACFF),
                child: Column(
                  children: [
                    widget.selectedLanguage ==  "english" ? Text ("Soomaali") : widget.selectedLanguage ==  "soomaali"  ? Text ("English") :widget.selectedLanguage ==  "arabic"? Text("English"):Text(""),
                  //  Text(widget.selectedLanguage ==  "english" ? "soomaali" ? widget.selectedLanguage ==  "english"  :"arabic"  ),
                  //  Text(translations['soomaali'] != null ? 'Soomaali' : ''),
                 widget.selectedLanguage ==  "english"?    Text(translations['soomaali'] ?? ''): widget.selectedLanguage ==  "soomaali" ?Text(translations['english'] ?? ''):widget.selectedLanguage ==  "arabic" ?Text(translations['english'] ?? ''):Text(""),
                  ],
                ),
              ),
              Container(
                 height: 200,
                width: MediaQuery.of(context).size.width /2,
                padding: EdgeInsets.all(16),
                color: Color(0xFFE1C7FF),
                child: Column(
                  children: [
                      widget.selectedLanguage ==  "english" ? Text ("Arabic") : widget.selectedLanguage ==  "soomaali"  ? Text ("Arabic") :widget.selectedLanguage ==  "arabic"? Text("Soomaali"):Text(""),
                 //   Text(translations['arabic'] != null ? 'Arabic' : ''),
                    widget.selectedLanguage ==  "english"?    Text(translations['arabic'] ?? ''): widget.selectedLanguage ==  "soomaali" ?Text(translations['arabic'] ?? ''):widget.selectedLanguage ==  "arabic" ?Text(translations['soomaali'] ?? ''):Text(""),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSuggestions(String query,String token) async {
    print(token);
    print(query);
    try {
      final response = await http.post(
        Uri.parse('https://translation.saeedantechpvt.com/api/app/search-translate'),
        headers: {
          'Authorization':"Bearer " + token, // Replace with your actual auth token
        },
        body: {
          'lang': query,
          // 'query': query,
        },
      );
print(response.statusCode);
      if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> dataListFromApi = data['data'];

        setState(() {
          dataList = dataListFromApi.cast<String>();
        });
      } else {
        // Handle error
        print('API call failed');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during API call: $e');
    }
  }

  Future<void> _getTranslation(String word, String lang) async {
    try {
      final response = await http.post(
        Uri.parse('https://translation.saeedantechpvt.com/api/app/get-translate'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
        body: {'lang': lang, 'word': word},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> translationsData = data['data']['translations'];

        setState(() {
          translations = translationsData;
        });
      } else {
        Fluttertoast.showToast(msg: 'Failed to get translation. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error during translation. Please try again.');
    }
  }


 Future<void> fetchExactTranslation(String query,String selectedLanguage,String token) async {
    print(token);
    print(query);
    print(selectedLanguage);
    try {
      final response = await http.post(
        Uri.parse('https://translation.saeedantechpvt.com/api/app/search-translate'),
        headers: {
          'Authorization':"Bearer " + token, // Replace with your actual auth token
        },
        body: {
          'lang': selectedLanguage,
          'word': query,
        },
      );
print(response.statusCode);
      if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> dataListFromApi = data['data'];

        setState(() {
          dataList = dataListFromApi.cast<String>();
        });
      } else {
        // Handle error
        print('API call failed');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during API call: $e');
    }
  }





   Future<void> fetch(String query,String token) async {
    print(token);
    try {
      final response = await http.post(
        Uri.parse('https://translation.saeedantechpvt.com/api/app/search-translate'),
        headers: {
          'Authorization':"Bearer " + token, // Replace with your actual auth token
        },
        body: {
          'lang': query,
          // 'query': query,
        },
      );
print(response.statusCode);
      if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> dataListFromApi = data['data'];

        setState(() {
          dataList = dataListFromApi.cast<String>();
        });
      } else {
        // Handle error
        print('API call failed');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during API call: $e');
    }
  }
}
class LanguageButton extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onPressed;

  LanguageButton({
    required this.language,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: isSelected ? MaterialStateProperty.all(Colors.blue) : null,
      ),
      child: Text(language),
    );
  }
}












// ... (imports)

class SearchScreen extends StatefulWidget {
  final String selectedLanguage;
  final String token;

  SearchScreen({required this.selectedLanguage, required this.token});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];
  Map<String, dynamic> translations = {};

  Future<void> _searchTranslate(String word, String lang) async {
    try {
      final response = await http.post(
        Uri.parse('https://translation.saeedantechpvt.com/api/app/search-translate'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
        body: {'lang': lang, 'word': word},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> translationsData = data['data']['translations'];

        setState(() {
          translations = translationsData;
        });
      } else {
        Fluttertoast.showToast(msg: 'Failed to get translations. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error during translation. Please try again.');
    }
  }

  Future<void> _getTranslation(String word, String lang) async {
    try {
      final response = await http.post(
        Uri.parse('https://translation.saeedantechpvt.com/api/app/get-translate'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
        body: {'lang': lang, 'word': word},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> translationsData = data['data']['translations'];

        setState(() {
          translations = translationsData;
        });
      } else {
        Fluttertoast.showToast(msg: 'Failed to get translation. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error during translation. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search and Translate'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchResults.clear();
                });
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchTranslate(value, widget.selectedLanguage);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter a word...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      _searchTranslate(searchController.text, widget.selectedLanguage);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                  onTap: () {
                    _getTranslation(searchResults[index], widget.selectedLanguage);
                  },
                );
              },
            ),
          ),
          if (translations.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Text(translations['soomaali'] != null ? 'Soomaali' : ''),
                      Text(translations['soomaali'] ?? ''),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.green,
                  child: Column(
                    children: [
                      Text(translations['arabic'] != null ? 'Arabic' : ''),
                      Text(translations['arabic'] ?? ''),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}