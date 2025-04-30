
import 'chapter.dart';

class Comics {
   String? category,name,image;
   late List<Chapters> chapter;


  Comics(this.category,  this.name,  this.image,  this.chapter);

  Comics.fromJson(Map<String,dynamic> json){
    category = json['Category'];
    if(json['Chapters']!=null) {
      chapter = List<Chapters>.empty(growable: true);
      json['Chapters'].forEach((element){
        chapter.add(Chapters.fromJson(element));
      });
    }
    image = json['Image'];
    name = json['Name'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data['Category']=category;
    data['Chapters']=chapter.map((element)=>element.toJson()).toList();
    data['Image']=image;
    data['Name']=name;
    return data;
  }
}

