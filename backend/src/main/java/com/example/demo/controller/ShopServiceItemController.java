package com.example.demo.controller;

import com.example.demo.entity.ShopService;
import com.example.demo.service.ShopServiceItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shop-services")
public class ShopServiceItemController {
    
    @Autowired
    private ShopServiceItemService shopServiceItemService;
    
    @GetMapping("/shop/{shopId}")
    public ResponseEntity<List<ShopService>> getServicesByShopId(@PathVariable Long shopId) {
        List<ShopService> services = shopServiceItemService.getServicesByShopId(shopId);
        return ResponseEntity.ok(services);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ShopService> getServiceById(@PathVariable Long id) {
        ShopService service = shopServiceItemService.getServiceById(id);
        if (service == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(service);
    }
    
    @PostMapping
    public ResponseEntity<ShopService> createService(@RequestBody ShopService service) {
        ShopService created = shopServiceItemService.saveService(service);
        return ResponseEntity.ok(created);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ShopService> updateService(@PathVariable Long id, @RequestBody ShopService service) {
        ShopService existing = shopServiceItemService.getServiceById(id);
        if (existing == null) {
            return ResponseEntity.notFound().build();
        }
        service.setId(id);
        ShopService updated = shopServiceItemService.saveService(service);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteService(@PathVariable Long id) {
        shopServiceItemService.deleteService(id);
        return ResponseEntity.noContent().build();
    }
}