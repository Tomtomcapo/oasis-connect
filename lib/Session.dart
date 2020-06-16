class Session extends Object {
  static String cookie;
  static String PHPSESSID;
  static String bo_oasis_polytech_parisyear;

  static String cookiesToString() {
    return "PHPSESSID=" + PHPSESSID + ";bo_oasis_polytech_parisyear=" + bo_oasis_polytech_parisyear + ";";
  }
}