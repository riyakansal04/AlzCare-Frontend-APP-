import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  bool isLoading = true;

  // Fields
  String? name, age, contactNumber, emergencyContact;
  String? bloodGroup, illness, allergies, medications;
  String? sleepHours, alzheimer, drugAllergy, memoryLoss, neuroDisorder;
  String? userEmail;
  String? imageUrl;

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> sleepOptions = ['No sleep', '2-4 hours', '4-6 hours', '6-8 hours'];
  final List<String> yesNo = ['Yes', 'No'];

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email;
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          name = data['name'];
          age = data['age'];
          contactNumber = data['contactNumber'];
          emergencyContact = data['emergencyContact'];
          bloodGroup = data['bloodGroup'];
          illness = data['illness'];
          allergies = data['allergies'];
          medications = data['medications'];
          sleepHours = data['sleepHours'];
          alzheimer = data['alzheimer'];
          drugAllergy = data['drugAllergy'];
          memoryLoss = data['memoryLoss'];
          neuroDisorder = data['neuroDisorder'];
          imageUrl = data['imageUrl'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<String?> uploadImage(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final ref = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? uploadedUrl = imageUrl;

        if (_pickedImage != null) {
          uploadedUrl = await uploadImage(_pickedImage!);
          // Add cache buster query parameter to force reload
          uploadedUrl = '$uploadedUrl?${DateTime.now().millisecondsSinceEpoch}';
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'age': age,
          'contactNumber': contactNumber,
          'emergencyContact': emergencyContact,
          'email': user.email,
          'bloodGroup': bloodGroup,
          'illness': illness,
          'allergies': allergies,
          'medications': medications,
          'sleepHours': sleepHours,
          'alzheimer': alzheimer,
          'drugAllergy': drugAllergy,
          'memoryLoss': memoryLoss,
          'neuroDisorder': neuroDisorder,
          'imageUrl': uploadedUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          isEditing = false;
          imageUrl = uploadedUrl;
          _pickedImage = null; // clear picked image
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    }
  }

  Widget buildDisplayCard({required IconData icon, required String label, required String? value}) {
    return Card(
      color: Color(0xFFfcefdc),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF755b48)),
        title: Text(label, style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color:Color(0xFF755b48) ),),
        subtitle: Text(value ?? 'Not set', style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.bold, color:Color(0xFF755b48) )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEACCA9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF755b48),
        foregroundColor: Color(0xFFEACCA9) ,
        title: Text('My Profile', style: GoogleFonts.merriweather(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color(0xFFfcefdc),
        onPressed: () {
          if (isEditing) {
            saveProfile();
          } else {
            setState(() => isEditing = true);
          }
        },
        child: Icon(isEditing ? Icons.save : Icons.edit, color: Color(0xFF755b48),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isEditing ? buildEditForm() : buildViewMode(),
      ),
    );
  }

  Widget buildViewMode() {
    return ListView(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFfcefdc), 
            backgroundImage: _pickedImage != null
                ? FileImage(_pickedImage!)
                : (imageUrl != null ? NetworkImage(imageUrl!) : null) as ImageProvider?,
            child: (imageUrl == null && _pickedImage == null)
                ? const Icon(Icons.person, size: 50, color:Color(0xFF755b48))
                : null,
          ),
        ),
        const SizedBox(height: 16),

        Text("Personal Details", style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF755b48))),
        buildDisplayCard(icon: Icons.person, label: 'Name', value: name),
        buildDisplayCard(icon: Icons.cake, label: 'Age', value: age),
        buildDisplayCard(icon: Icons.phone, label: 'Contact Number', value: contactNumber),
        buildDisplayCard(icon: Icons.call, label: 'Emergency Contact', value: emergencyContact),
        buildDisplayCard(icon: Icons.email, label: 'Email', value: userEmail),

        const SizedBox(height: 20),
        Text("Medical Details", style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF755b48))),
        buildDisplayCard(icon: Icons.bloodtype, label: 'Blood Group', value: bloodGroup),
        buildDisplayCard(icon: Icons.nightlight_round, label: 'Sleep Duration', value: sleepHours),
        buildDisplayCard(icon: Icons.psychology, label: 'Alzheimer’s Patient', value: alzheimer),
        buildDisplayCard(icon: Icons.warning_amber_rounded, label: 'Drug Allergy', value: drugAllergy),
        buildDisplayCard(icon: Icons.memory, label: 'Recent Memory Loss', value: memoryLoss),
        buildDisplayCard(icon: Icons.memory, label: 'Neurological Disorder', value: neuroDisorder),
        buildDisplayCard(icon: Icons.healing, label: 'Chronic Illness', value: illness),
        buildDisplayCard(icon: Icons.warning, label: 'Allergies', value: allergies),
        buildDisplayCard(icon: Icons.medical_services, label: 'Medications', value: medications),
      ],
    );
  }

  Widget buildEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFfcefdc),
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (imageUrl != null ? NetworkImage(imageUrl!) : null) as ImageProvider?,
                  child: (imageUrl == null && _pickedImage == null)
                      ? const Icon(Icons.person, size: 50, color: Color(0xFF755b48),)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF755B48),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt, color: Color(0xFFfcefdc), size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text("Personal Details", style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF755b48))),
          TextFormField(
            initialValue: name,
            decoration: InputDecoration(
    labelText: 'Name',
    labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),
  ),
           style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ), onSaved: (val) => name = val,
            validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
          ),
          TextFormField(
            initialValue: age,
            decoration: InputDecoration(labelText: 'Age', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),
    style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            keyboardType: TextInputType.number,
            onSaved: (val) => age = val,
          ),
          TextFormField(
            initialValue: contactNumber,
            decoration: InputDecoration(labelText: 'Contact Number', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            keyboardType: TextInputType.phone,
            onSaved: (val) => contactNumber = val,
          ),
          TextFormField(
            initialValue: emergencyContact,
            decoration: InputDecoration(labelText: 'Emergency Contact', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            keyboardType: TextInputType.phone,
            onSaved: (val) => emergencyContact = val,
          ),
          const SizedBox(height: 16),

          Text("Medical Details", style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF755b48))),
          DropdownButtonFormField<String>(
            iconEnabledColor: Color(0xFF755b48),
          dropdownColor: Color(0xFFfcefdc),
            value: bloodGroup,
            decoration: InputDecoration(labelText: 'Blood Group', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            items: bloodGroups.map((group) {
              return DropdownMenuItem(value: group, child: Text(group));
            }).toList(),
            onChanged: (val) => setState(() => bloodGroup = val),
            validator: (val) => val == null ? 'Select your blood group' : null,
          ),
          DropdownButtonFormField<String>(
            iconEnabledColor: Color(0xFF755b48),
            dropdownColor: Color(0xFFfcefdc),
            value: sleepHours,
            decoration: InputDecoration(labelText: 'Sleep Duration', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            items: sleepOptions.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: (val) => setState(() => sleepHours = val),
          ),
          DropdownButtonFormField<String>(
            iconEnabledColor: Color(0xFF755b48),
            dropdownColor: Color(0xFFfcefdc),
            value: alzheimer,
            decoration: InputDecoration(labelText: 'Alzheimer’s Patient', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            items: yesNo.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: (val) => setState(() => alzheimer = val),
          ),
          DropdownButtonFormField<String>(
            iconEnabledColor: Color(0xFF755b48),
            dropdownColor: Color(0xFFfcefdc),
            value: drugAllergy,
            decoration: InputDecoration(labelText: 'Drug Allergy', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            items: yesNo.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: (val) => setState(() => drugAllergy = val),
          ),
                    DropdownButtonFormField<String>(
                      iconEnabledColor: Color(0xFF755b48),
                      dropdownColor: Color(0xFFfcefdc),
            value: memoryLoss,
            decoration: InputDecoration(labelText: 'Recent Memory Loss', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            items: yesNo.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: (val) => setState(() => memoryLoss = val),
          ),
          DropdownButtonFormField<String>(
            iconEnabledColor: Color(0xFF755b48),
            dropdownColor: Color(0xFFfcefdc),
            value: neuroDisorder,
            decoration: InputDecoration(labelText: 'Neurological Disorder', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            items: yesNo.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: (val) => setState(() => neuroDisorder = val),
          ),
          TextFormField(
            initialValue: illness,
            decoration: InputDecoration(labelText: 'Chronic Illness', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            onSaved: (val) => illness = val,
          ),
          TextFormField(
            initialValue: allergies,
            decoration: InputDecoration(labelText: 'Allergies', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ), 
            onSaved: (val) => allergies = val,
          ),
          TextFormField(
            initialValue: medications,
            decoration: InputDecoration(labelText: 'Medications', labelStyle: GoogleFonts.lora(
      color: Color(0xFF755b48), // label text color
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ), enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48)), // color when not focused
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF755b48), width: 2.0), // color when focused
    ),),style: GoogleFonts.lora( // input text style
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF755b48),
  ),
            onSaved: (val) => medications = val,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}