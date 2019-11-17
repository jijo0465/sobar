import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:kudians/app_id.dart';
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
  bool interstitialIsLoaded=false;
    static final MobileAdTargetingInfo targetingInfo= MobileAdTargetingInfo(
      testDevices: APP_ID !=null? [APP_ID] : null,
      keywords: ['Games','Puzzles']
    );
        InterstitialAd interstitialAd;
        
    InterstitialAd buildInterstitialAd(){
      return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          if(event==MobileAdEvent.failedToLoad){
            interstitialAd..load();
          }else if(event == MobileAdEvent.closed){
            interstitialAd = buildInterstitialAd()..load();
          }
        }
      );
    }
  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
      // bannerAd = buildBannerAd()..load();
      interstitialAd = buildInterstitialAd()..load();
      interstitialAd..load()..show();
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
         void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }
       @override
       Widget build(BuildContext context) {
        //  interstitialAd..load()..show();
         return Padding(
           padding: const EdgeInsets.fromLTRB(3,50,3,0),
           child: Container(
             child: Column(
               children: <Widget>[
                 AnimatedCrossFade(
                    firstChild: searchBar(),
                    secondChild:Container(child: Column(
                      children: <Widget>[
                                  Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(8,12,0,0),
                            child: Text('BEVCO Price List',
                              style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.w500, letterSpacing: 0.3),),
                          ),
                        searchBar(),
                      ],
                    )),
                    duration: const Duration(milliseconds: 210),
                    crossFadeState: isFocus ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
                 onTap: (){
                   if(isFocus){
                      FocusScope.of(context).requestFocus(FocusNode());
                   }
                     },
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
                 ),
             decoration: BoxDecoration(color: Colors.orange[200], borderRadius: BorderRadius.circular(12)),
           ),);
           
         },
       );
     }
     Widget searchBar(){
       return 
                  Container(
                       height: 70,
                       padding: EdgeInsets.all(12),
                       child: ClipRect(
                          child: BackdropFilter(
                            child:DecoratedBox(
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
                       ), filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0,
                       
                     ), ),
         ),
       );
     }
       void _onFocusChange() {
         setState(() {
          isFocus=_focusNode.hasFocus; 
         });
  }
}