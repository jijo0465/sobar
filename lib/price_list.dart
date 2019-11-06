import 'package:flutter/material.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/kuppi.dart';
import 'package:kudians/price_list_cache.dart';

class PriceList extends StatefulWidget{
  const PriceList();
  @override
  State<PriceList> createState() {
    return _PriceList();
  }
}

class _PriceList  extends State<PriceList>{
  FocusNode _focusNode=FocusNode();
  List<Kuppi> kuppi;
  List<Kuppi> filteredKuppi= List();
  String _searchText="";
  List<String> tempNames;
  TextEditingController _searchController=TextEditingController();
  bool isFocus=false;
  @override
  void initState() {
    kuppi = List<Kuppi>();
     _focusNode.addListener(_onFocusChange);
         if(PriceListCache().isCached()){
           kuppi=PriceListCache().getAllKuppi();
           setState(() {
            filteredKuppi=kuppi;
           });
         }else{
           FirebaseServices().getAllKuppi().then((value){
           kuppi=value;
           setState(() {
            filteredKuppi=kuppi;
           });
         });
         }
         
         _searchController.addListener((){
           if (_searchController.text.isEmpty) {
             setState(() {
               _searchText = "";
               filteredKuppi=kuppi;
             });
           } else {
             setState(() {
               _searchText = _searchController.text;
             });
           }
         });
         super.initState();
       }
       @override
       Widget build(BuildContext context) {
         return Padding(
           padding: const EdgeInsets.fromLTRB(3,50,3,0),
           child: Container(
             child: Column(
               children: <Widget>[
                 Container(
                   alignment: Alignment.centerLeft,
                   padding: EdgeInsets.fromLTRB(8,12,0,0),
                   child: Text('BEVCO Price List',style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold),),
                 ),
                 Container(
                   height: 70,
                   padding: EdgeInsets.all(12),
                   child: DecoratedBox(
                     position: DecorationPosition.background,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(12)),
                       color: Colors.white12,
                       shape: BoxShape.rectangle,
                       border: Border.all(color: Colors.black26,)
                     ),
                     child: TextField(
                       style: TextStyle(
                         color: Colors.deepOrangeAccent[100]
                       ),
                       cursorColor: Colors.deepOrange,
                       
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                      
                       border: InputBorder.none,
                       suffixIcon: isFocus?IconButton(
                         icon: Icon(Icons.close,
                          color: Colors.orangeAccent,),
                          onPressed:(){
                            FocusScope.of(context).requestFocus(FocusNode());
                            
                              _searchController.text='';
                          
                            }): 
                          Icon(Icons.search,color: Colors.white,),
                       contentPadding: EdgeInsets.fromLTRB(12, 2, 4, 0),
                       prefixText: "",
                       labelText: "Search..",
                       
                       labelStyle: TextStyle(
                         color: Colors.white
                       )
                     ),
                     controller: _searchController,
                     
                   ),
                   )
                   
                 ),
                 Flexible(
                   child: Container(
                     child: _buildList(),
                     ),
                 )
               ],
             ),
           )
         );
       }
       Widget _buildList() {
       if (_searchText.isNotEmpty) {
         List<Kuppi> tempKuppi = List<Kuppi>();
         for (int i = 0; i < kuppi.length; i++) {
           if (kuppi[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
             tempKuppi.add(kuppi[i]);
           }
         }
         filteredKuppi=tempKuppi;
       }
       return ListView.builder(
         itemCount: kuppi.length==0 ? 0 : filteredKuppi.length,
         itemBuilder: (BuildContext context, int index) {
           return Card(
             elevation: 6,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12)
             ),
             child: Container(
               child: ListTile(
                 isThreeLine: false,
                 title: Text(filteredKuppi[index].name),
                 subtitle: Padding(
                   padding: const EdgeInsets.only(top: 8),
                   child: Row(
                     children: <Widget>[
                       Expanded(child: Text("Category: "+filteredKuppi[index].category),),
                       Expanded(child: Text("Size: "+filteredKuppi[index].size),),
                     ],
                   ),
                 ),
                 trailing: Text("₹ "+filteredKuppi[index].price.toString(),style: TextStyle(fontSize: 20),),
                 onTap: (){},
                 ),
             decoration: BoxDecoration(color: Colors.orange[200], borderRadius: BorderRadius.circular(12)),
           ),);
           
         },
       );
     }
     
       void _onFocusChange() {
         setState(() {
          isFocus=_focusNode.hasFocus; 
         });
  }
}