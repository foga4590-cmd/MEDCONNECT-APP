// ===================== Sign Up Screen  =====================
import 'package:flutter/material.dart';
import 'package:medconnect_app/homeScreen.dart';
import 'package:medconnect_app/signInScreen.dart';
import 'package:flutter/services.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedAuthority;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
 
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0066FF), Color(0xFF0088FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // زرار الرجوع للـ Intro
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                     Image.asset("assets/images/logoPNG.png", color: Colors.white, fit: BoxFit.cover, height: 40),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // الصورة الشخصية في اليمين + أيقونة الكاميرا
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.person, size: 60, color: Colors.white),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF0066FF),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                  onPressed: () {
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    const Text('User Information', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    _buildTextField(label: 'Full Name (As On National ID)', validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (RegExp(r'[0-9]').hasMatch(v)) return 'No numbers allowed';
                      return null;
                    }),

                    _buildTextField(
                      label: 'National ID Number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(14)],
                      validator: (v) => v?.length != 14 ? 'Must be 14 digits' : null,
                    ),

                    _buildTextField(label: 'Address', suffixIcon: const Icon(Icons.location_on_outlined, color: Colors.blue)),

                    const SizedBox(height: 32),
                    const Text('Account Information', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!) ? 'Invalid email' : null,
                    ),

                    _buildTextField(
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                      validator: (v) => v?.length != 11 ? 'Must be 11 digits' : null,
                    ),

            _buildTextField(
             label: 'Password',
             controller: _passwordController,
            obscureText: _obscurePassword,
             suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
             onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
             validator: (v) {
  if (v == null || v.isEmpty) return 'Required';
  if (v.length < 8) return 'At least 8 characters';
  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*[\d@#$!%*?&]).+$').hasMatch(v)) {
    return 'Letters + numbers/symbols';
  }
  return null;
},
                    ),

                    _buildTextField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                    ),

                    const SizedBox(height: 32),
                    const Text('Professional License Requirements', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Medical Practice License Number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    _buildTextField(
                      label: 'Issuing Authority',
                      readOnly: true,
                      hintText: _selectedAuthority ?? 'Select Authority',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      onTap: () async {
                        final selected = await showDialog<String>(
                          context: context,
                          builder: (_) => SimpleDialog(
                            title: const Text('Issuing Authority'),
                            children: [
                              SimpleDialogOption(child: const Text('Ministry of health'), onPressed: () => Navigator.pop(context, 'ministry of health')),
                              SimpleDialogOption(child: const Text('Doctors syndicate'), onPressed: () => Navigator.pop(context, 'doctors syndicate')),
                            ],
                          ),
                        );
                        if (selected != null) setState(() => _selectedAuthority = selected);
                      },
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                          }
                        },
                        child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already Have An Account? ', style: TextStyle(color: Colors.black54)),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                          child: const Text('Sign In', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function()? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
        validator: validator,
      ),
    );
  }
}
