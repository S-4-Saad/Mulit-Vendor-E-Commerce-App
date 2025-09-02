//---------------API-base url-------------
const String baseUrl = "https://speezu.com/public/api";
const String imageBaseUrl = "https://speezu.com/public/";

///-----------Auth Apis-----------------///
const String registerUserUrl = "$baseUrl/register";
const String loginUserUrl = "$baseUrl/login";
const String resetPasswordUrl = "$baseUrl/send_reset_link_email";

///-----------Fetch Dashboard Banner Apis-----------------///
const String dashboardBannersUrl = "$baseUrl/dashboard-banners";
///-----------Product Apis-----------------///
const String getProducts = "$baseUrl/getProducts";
const String getProductDetail = "$baseUrl/getProductsDetail";
const String getCategories = "$baseUrl/getCategories";


///-----------Order Apis-----------------///
const String getOrdersUrl = "$baseUrl/GetOrders";
const String getOrderDetailsUrl = "$baseUrl/GetOrderDetail";


///-----------Cart Apis-----------------///
const String placeOrderUrl = "$baseUrl/placeOrder";


///-----------Address Apis-----------------///
const String addAddressUrl = "$baseUrl/storeAddress";
const String deleteAddressUrl = "$baseUrl/DeleteAddress";

///-----------Filter Tags Apis-----------------///
const String filterTagsUrl = "$baseUrl/getSubCategories";

///-----------Store Detail Apis-----------------///
const String storeDetailUrl = "$baseUrl/getStoreDetails";
///-----------Category Products Apis-----------------///
const String categoryProductsUrl = "$baseUrl/searchProducts";
///-----------WishList Products Apis-----------------///
const String wishListUrl = "$baseUrl/getWishlist";
///-----------ToggleWishList  Apis-----------------///
const String toggleWishListUrl = "$baseUrl/toggleWishlist";
///-----------SubmitReview  Apis-----------------///
const String submitReviewUrl = "$baseUrl/storeReview";
///-----------Fetch My Reviews Apis-----------------///
const String myReviewUrl = "$baseUrl/getReview";
///-----------Fetch My Reviews Apis-----------------///
const String logOutUrl = "$baseUrl/logout";
///-----------Fetch Support Center Apis-----------------///
const String supportCenterUrl = "$baseUrl/getHelpCenterDetails";
///-----------Fetch Complaint  Apis-----------------///
const String complaintUrl = "$baseUrl/AddComplaints";
