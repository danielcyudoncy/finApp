// screens/collaboration_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/collaboration.dart';

class CollaborationScreen extends StatelessWidget {
  const CollaborationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final groups = provider.userCollaborationGroups;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Collaboration'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateGroupDialog(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active Groups
                Text(
                  'My Groups',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildGroupsList(context, groups),
                const SizedBox(height: 24),

                // Invitations
                Text(
                  'Invitations',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildInvitationsList(provider, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsList(BuildContext context, List<CollaborationGroup> groups) {
    if (groups.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No collaboration groups yet'),
        ),
      );
    }

    return Column(
      children: groups.map((group) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              child: const Icon(Icons.group, color: Colors.blue),
            ),
            title: Text(group.name),
            subtitle: Text('${group.members.length} members'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToGroupDetails(context, group);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInvitationsList(FinanceProvider provider, BuildContext context) {
    // Get pending invitations only
    final invitations = provider.collaborationInvitations
        .where((invitation) => invitation.isPending)
        .toList();

    if (invitations.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No pending invitations'),
        ),
      );
    }

    return Column(
      children: invitations.map((invitation) {
        return Card(
          color: invitation.isExpired ? Colors.grey.withValues(alpha: 0.1) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invitation.groupName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Invited by ${invitation.invitedByName}'),
                          if (invitation.message != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              invitation.message!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            'Expires: ${invitation.expiresAt.day}/${invitation.expiresAt.month}/${invitation.expiresAt.year}',
                            style: TextStyle(
                              color: invitation.isExpired ? Colors.red : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        invitation.role.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: invitation.isExpired ? null : () {
                          provider.acceptInvitation(invitation.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Accepted invitation to ${invitation.groupName}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: invitation.isExpired ? null : () {
                          _showDeclineConfirmationDialog(context, provider, invitation);
                        },
                        child: const Text('Decline'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDeclineConfirmationDialog(BuildContext context, FinanceProvider provider, CollaborationInvitation invitation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Decline Invitation'),
          content: Text('Are you sure you want to decline the invitation to "${invitation.groupName}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                provider.declineInvitation(invitation.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Declined invitation to ${invitation.groupName}'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Decline', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String groupName = '';
    String groupDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Group'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                    hintText: 'Enter group name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Group name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Group name must be at least 3 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => groupName = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter group description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) => groupDescription = value?.trim() ?? '',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            Consumer<FinanceProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      try {
                        // Create new group
                        final newGroup = CollaborationGroup(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: groupName,
                          description: groupDescription,
                          ownerId: 'user1', // Current user ID
                          createdDate: DateTime.now(),
                          members: [
                            CollaborationMember(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              userId: 'user1',
                              email: 'user1@example.com', // This should come from user profile
                              name: 'Current User', // This should come from user profile
                              role: CollaborationRole.owner,
                              joinedDate: DateTime.now(),
                            ),
                          ],
                        );

                        provider.addCollaborationGroup(newGroup);

                        Navigator.of(context).pop(); // Close dialog

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Created group "$groupName"'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to create group: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Create'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToGroupDetails(BuildContext context, CollaborationGroup group) {
    // For now, show a simple dialog with group details
    // In a real app, this would navigate to a dedicated group details screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(group.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.description.isNotEmpty) ...[
                Text(
                  'Description:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(group.description),
                const SizedBox(height: 16),
              ],
              Text(
                'Members (${group.members.length}):',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...group.members.map((member) => Text(
                '${member.name} (${member.role.name})',
                style: TextStyle(
                  color: member.role == CollaborationRole.owner ? Colors.blue : Colors.black,
                ),
              )),
              const SizedBox(height: 16),
              Text(
                'Created: ${group.createdDate.day}/${group.createdDate.month}/${group.createdDate.year}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}