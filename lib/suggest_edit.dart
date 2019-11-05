import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudians/bottom_sheet_title.dart';
import 'package:kudians/editor_page.dart';
import 'package:kudians/place_data.dart';
import 'package:kudians/sobar_divider.dart';

class SuggestEdit extends StatelessWidget{
  final PlaceData placeData;
  final String type;
  const SuggestEdit({Key key, @required this.placeData, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SobarDivider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            title: BottomSheetTitle(title:"Suggest an edit"),
            trailing: Icon(Icons.edit,color: Colors.orange[900]),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return EditorPage(placeData: placeData,type: type,);
              }));
            },
          ),
          SobarDivider(),
        ],
      ),
    );
  }
}
