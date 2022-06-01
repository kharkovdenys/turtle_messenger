/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Chatdata type in your schema. */
@immutable
class Chatdata extends Model {
  static const classType = const _ChatdataModelType();
  final String id;
  final String? _message;
  final List<String>? _media;
  final TemporalTimestamp? _createdAt;
  final TemporalTimestamp? _updatedAt;
  final String? _chatId;
  final String? _senderId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get message {
    return _message;
  }
  
  List<String>? get media {
    return _media;
  }
  
  TemporalTimestamp? get createdAt {
    return _createdAt;
  }
  
  TemporalTimestamp? get updatedAt {
    return _updatedAt;
  }
  
  String? get chatId {
    return _chatId;
  }
  
  String? get senderId {
    return _senderId;
  }
  
  const Chatdata._internal({required this.id, message, media, createdAt, updatedAt, chatId, senderId}): _message = message, _media = media, _createdAt = createdAt, _updatedAt = updatedAt, _chatId = chatId, _senderId = senderId;
  
  factory Chatdata({String? id, String? message, List<String>? media, TemporalTimestamp? createdAt, TemporalTimestamp? updatedAt, String? chatId, String? senderId}) {
    return Chatdata._internal(
      id: id == null ? UUID.getUUID() : id,
      message: message,
      media: media != null ? List<String>.unmodifiable(media) : media,
      createdAt: createdAt,
      updatedAt: updatedAt,
      chatId: chatId,
      senderId: senderId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chatdata &&
      id == other.id &&
      _message == other._message &&
      DeepCollectionEquality().equals(_media, other._media) &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      _chatId == other._chatId &&
      _senderId == other._senderId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Chatdata {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("media=" + (_media != null ? _media!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.toString() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.toString() : "null") + ", ");
    buffer.write("chatId=" + "$_chatId" + ", ");
    buffer.write("senderId=" + "$_senderId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Chatdata copyWith({String? id, String? message, List<String>? media, TemporalTimestamp? createdAt, TemporalTimestamp? updatedAt, String? chatId, String? senderId}) {
    return Chatdata._internal(
      id: id ?? this.id,
      message: message ?? this.message,
      media: media ?? this.media,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId);
  }
  
  Chatdata.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _message = json['message'],
      _media = json['media']?.cast<String>(),
      _createdAt = json['createdAt'] != null ? TemporalTimestamp.fromSeconds(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalTimestamp.fromSeconds(json['updatedAt']) : null,
      _chatId = json['chatId'],
      _senderId = json['senderId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'message': _message, 'media': _media, 'createdAt': _createdAt?.toSeconds(), 'updatedAt': _updatedAt?.toSeconds(), 'chatId': _chatId, 'senderId': _senderId
  };

  static final QueryField ID = QueryField(fieldName: "chatdata.id");
  static final QueryField MESSAGE = QueryField(fieldName: "message");
  static final QueryField MEDIA = QueryField(fieldName: "media");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField UPDATEDAT = QueryField(fieldName: "updatedAt");
  static final QueryField CHATID = QueryField(fieldName: "chatId");
  static final QueryField SENDERID = QueryField(fieldName: "senderId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Chatdata";
    modelSchemaDefinition.pluralName = "Chatdata";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Chatdata.MESSAGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Chatdata.MEDIA,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Chatdata.CREATEDAT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Chatdata.UPDATEDAT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Chatdata.CHATID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Chatdata.SENDERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ChatdataModelType extends ModelType<Chatdata> {
  const _ChatdataModelType();
  
  @override
  Chatdata fromJson(Map<String, dynamic> jsonData) {
    return Chatdata.fromJson(jsonData);
  }
}