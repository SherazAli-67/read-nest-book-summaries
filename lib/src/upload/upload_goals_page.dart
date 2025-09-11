import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/reading_goal_model.dart';

class UploadGoalsPage extends StatelessWidget{
  const UploadGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text("Reading Goals Management", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: uploadPredefinedGoals,
                child: Text("Upload Predefined Goals")
              ),
              Text("This will create goal templates in Firebase", 
                   style: TextStyle(fontSize: 12, color: Colors.grey))
            ],
          )
        )
      ),
    );
  }

  /// Uploads predefined reading goals to Firebase
  Future<void> uploadPredefinedGoals() async {
    try {
      debugPrint("Starting upload of predefined reading goals...");
      
      final goalsCollection = FirebaseFirestore.instance.collection('reading_goal_templates');
      final predefinedGoals = ReadingGoal.getPredefinedGoals();
      
      // Upload each goal
      for (final goal in predefinedGoals) {
        await goalsCollection.doc(goal.goalId).set(goal.toMap());
        debugPrint("Uploaded goal: ${goal.title}");
      }
      
      debugPrint("Successfully uploaded ${predefinedGoals.length} reading goals");
    } catch (e) {
      debugPrint("Error uploading reading goals: $e");
    }
  }

}
