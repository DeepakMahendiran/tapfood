package com.tap.model;

public class UserAddress {
    private int addressId;
    private int userId;
    private String label;
    private String addressLine;
    private String city;
    private String phone;

    public UserAddress() {
    }

    public UserAddress(int userId, String label, String addressLine, String city, String phone) {
        this.userId = userId;
        this.label = label;
        this.addressLine = addressLine;
        this.city = city;
        this.phone = phone;
    }

    public UserAddress(int addressId, int userId, String label, String addressLine, String city, String phone) {
        this.addressId = addressId;
        this.userId = userId;
        this.label = label;
        this.addressLine = addressLine;
        this.city = city;
        this.phone = phone;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getAddressLine() {
        return addressLine;
    }

    public void setAddressLine(String addressLine) {
        this.addressLine = addressLine;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    /** Single line form used when stamping the address onto an order. */
    public String toDeliveryString() {
        StringBuilder sb = new StringBuilder();
        sb.append(addressLine);
        if (city != null && !city.trim().isEmpty()) sb.append(", ").append(city);
        if (phone != null && !phone.trim().isEmpty()) sb.append(" (Ph: ").append(phone).append(")");
        return sb.toString();
    }

    @Override
    public String toString() {
        return "UserAddress [addressId=" + addressId + ", userId=" + userId + ", label=" + label
                + ", addressLine=" + addressLine + ", city=" + city + ", phone=" + phone + "]";
    }
}
