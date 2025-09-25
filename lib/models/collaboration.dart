// models/collaboration.dart

enum CollaborationRole {
  owner,
  admin,
  editor,
  viewer,
}

enum InvitationStatus {
  pending,
  accepted,
  declined,
  expired,
}

enum SharedItemType {
  budget,
  goal,
  account,
  transaction,
  report,
}

class CollaborationGroup {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final List<CollaborationMember> members;
  final List<SharedItem> sharedItems;
  final DateTime createdDate;
  final bool isActive;
  final Map<String, dynamic> settings;

  CollaborationGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    this.members = const [],
    this.sharedItems = const [],
    required this.createdDate,
    this.isActive = true,
    this.settings = const {},
  });

  bool get isOwner => members.any((m) => m.userId == ownerId && m.role == CollaborationRole.owner);
  List<CollaborationMember> get admins => members.where((m) => m.role == CollaborationRole.admin).toList();
  List<CollaborationMember> get editors => members.where((m) => m.role == CollaborationRole.editor).toList();
  List<CollaborationMember> get viewers => members.where((m) => m.role == CollaborationRole.viewer).toList();

  CollaborationGroup copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    List<CollaborationMember>? members,
    List<SharedItem>? sharedItems,
    DateTime? createdDate,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) {
    return CollaborationGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      sharedItems: sharedItems ?? this.sharedItems,
      createdDate: createdDate ?? this.createdDate,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'members': members.map((m) => m.toJson()).toList(),
      'sharedItems': sharedItems.map((s) => s.toJson()).toList(),
      'createdDate': createdDate.toIso8601String(),
      'isActive': isActive,
      'settings': settings,
    };
  }

  factory CollaborationGroup.fromJson(Map<String, dynamic> json) {
    return CollaborationGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ownerId: json['ownerId'],
      members: (json['members'] as List<dynamic>?)
              ?.map((m) => CollaborationMember.fromJson(m))
              .toList() ??
          [],
      sharedItems: (json['sharedItems'] as List<dynamic>?)
              ?.map((s) => SharedItem.fromJson(s))
              .toList() ??
          [],
      createdDate: DateTime.parse(json['createdDate']),
      isActive: json['isActive'] ?? true,
      settings: json['settings'] ?? {},
    );
  }
}

class CollaborationMember {
  final String id;
  final String userId;
  final String email;
  final String name;
  final CollaborationRole role;
  final DateTime joinedDate;
  final bool isActive;
  final Map<String, dynamic> permissions;

  CollaborationMember({
    required this.id,
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
    required this.joinedDate,
    this.isActive = true,
    this.permissions = const {},
  });

  bool hasPermission(String permission) => permissions[permission] == true;

  CollaborationMember copyWith({
    String? id,
    String? userId,
    String? email,
    String? name,
    CollaborationRole? role,
    DateTime? joinedDate,
    bool? isActive,
    Map<String, dynamic>? permissions,
  }) {
    return CollaborationMember(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      joinedDate: joinedDate ?? this.joinedDate,
      isActive: isActive ?? this.isActive,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'name': name,
      'role': role.index,
      'joinedDate': joinedDate.toIso8601String(),
      'isActive': isActive,
      'permissions': permissions,
    };
  }

  factory CollaborationMember.fromJson(Map<String, dynamic> json) {
    return CollaborationMember(
      id: json['id'],
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      role: CollaborationRole.values[json['role']],
      joinedDate: DateTime.parse(json['joinedDate']),
      isActive: json['isActive'] ?? true,
      permissions: json['permissions'] ?? {},
    );
  }
}

class SharedItem {
  final String id;
  final SharedItemType type;
  final String itemId;
  final String itemName;
  final String sharedByUserId;
  final List<String> sharedWithUserIds;
  final DateTime sharedDate;
  final Map<String, dynamic> permissions;

  SharedItem({
    required this.id,
    required this.type,
    required this.itemId,
    required this.itemName,
    required this.sharedByUserId,
    required this.sharedWithUserIds,
    required this.sharedDate,
    this.permissions = const {},
  });

  SharedItem copyWith({
    String? id,
    SharedItemType? type,
    String? itemId,
    String? itemName,
    String? sharedByUserId,
    List<String>? sharedWithUserIds,
    DateTime? sharedDate,
    Map<String, dynamic>? permissions,
  }) {
    return SharedItem(
      id: id ?? this.id,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      sharedByUserId: sharedByUserId ?? this.sharedByUserId,
      sharedWithUserIds: sharedWithUserIds ?? this.sharedWithUserIds,
      sharedDate: sharedDate ?? this.sharedDate,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'itemId': itemId,
      'itemName': itemName,
      'sharedByUserId': sharedByUserId,
      'sharedWithUserIds': sharedWithUserIds,
      'sharedDate': sharedDate.toIso8601String(),
      'permissions': permissions,
    };
  }

  factory SharedItem.fromJson(Map<String, dynamic> json) {
    return SharedItem(
      id: json['id'],
      type: SharedItemType.values[json['type']],
      itemId: json['itemId'],
      itemName: json['itemName'],
      sharedByUserId: json['sharedByUserId'],
      sharedWithUserIds: List<String>.from(json['sharedWithUserIds']),
      sharedDate: DateTime.parse(json['sharedDate']),
      permissions: json['permissions'] ?? {},
    );
  }
}

class CollaborationInvitation {
  final String id;
  final String groupId;
  final String groupName;
  final String invitedByUserId;
  final String invitedByName;
  final String inviteeEmail;
  final CollaborationRole role;
  final String? message;
  final InvitationStatus status;
  final DateTime sentDate;
  final DateTime? respondedDate;
  final DateTime expiresAt;

  CollaborationInvitation({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.invitedByUserId,
    required this.invitedByName,
    required this.inviteeEmail,
    required this.role,
    this.message,
    this.status = InvitationStatus.pending,
    required this.sentDate,
    this.respondedDate,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isPending => status == InvitationStatus.pending && !isExpired;

  CollaborationInvitation copyWith({
    String? id,
    String? groupId,
    String? groupName,
    String? invitedByUserId,
    String? invitedByName,
    String? inviteeEmail,
    CollaborationRole? role,
    String? message,
    InvitationStatus? status,
    DateTime? sentDate,
    DateTime? respondedDate,
    DateTime? expiresAt,
  }) {
    return CollaborationInvitation(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      invitedByUserId: invitedByUserId ?? this.invitedByUserId,
      invitedByName: invitedByName ?? this.invitedByName,
      inviteeEmail: inviteeEmail ?? this.inviteeEmail,
      role: role ?? this.role,
      message: message ?? this.message,
      status: status ?? this.status,
      sentDate: sentDate ?? this.sentDate,
      respondedDate: respondedDate ?? this.respondedDate,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'groupName': groupName,
      'invitedByUserId': invitedByUserId,
      'invitedByName': invitedByName,
      'inviteeEmail': inviteeEmail,
      'role': role.index,
      'message': message,
      'status': status.index,
      'sentDate': sentDate.toIso8601String(),
      'respondedDate': respondedDate?.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory CollaborationInvitation.fromJson(Map<String, dynamic> json) {
    return CollaborationInvitation(
      id: json['id'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      invitedByUserId: json['invitedByUserId'],
      invitedByName: json['invitedByName'],
      inviteeEmail: json['inviteeEmail'],
      role: CollaborationRole.values[json['role']],
      message: json['message'],
      status: InvitationStatus.values[json['status']],
      sentDate: DateTime.parse(json['sentDate']),
      respondedDate: json['respondedDate'] != null ? DateTime.parse(json['respondedDate']) : null,
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}