package Server;

import java.util.ArrayList;

public class LoginValidation {

	static ArrayList<String> emails = new ArrayList<>();
	static ArrayList<String> passwords = new ArrayList<>();

	static {
		emails.add("aarav@gmail.com");
		passwords.add("a12345678");

		emails.add("teacher.anna@school.com");
		passwords.add("anna@2024");

		emails.add("rahul.sharma@gmail.com");
		passwords.add("rahul@123");
	}

	public static boolean validate(String email, String password) {

		for (int i = 0; i < emails.size(); i++) {

			if (emails.get(i).equals(email) && passwords.get(i).equals(password)) {
				return true;
			}
		}

		return false;
	}
}