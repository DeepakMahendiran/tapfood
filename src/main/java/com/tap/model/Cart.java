package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    Map<Integer, CartItem> items;

    public Cart() {
        items = new HashMap<Integer, CartItem>();
    }

    public void addItem(Menu menu, int quantity) {
        if (items.containsKey(menu.getMenuId())) {
            CartItem existingItem = items.get(menu.getMenuId());
            existingItem.setQty(existingItem.getQty() + quantity);
        } else {
            CartItem item = new CartItem(
                    menu.getMenuId(), menu.getRestaurantId(), menu.getItemName(),
                    menu.getPrice(), quantity, menu.getImagePath());
            items.put(menu.getMenuId(), item);
        }
    }

    public void updateItem(int menuId, int qty) {
        if (items.containsKey(menuId)) {
            if (qty <= 0) items.remove(menuId);
            else items.get(menuId).setQty(qty);
        }
    }

    public void remove(int menuId) {
        items.remove(menuId);
    }

    public double getTotal() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getPrice() * item.getQty();
        }
        return total;
    }

    public int getRestaurantId() {
        for (CartItem item : items.values()) {
            return item.getRestaurantId();
        }
        return 0;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }
}