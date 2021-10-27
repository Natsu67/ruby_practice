class ShopInventory

    def initialize(inventory)
        @inventory = inventory
    end

    def item_in_stock
        items_in_stock = @inventory.filter_map{|item| item[:name] unless item[:quantity_by_size].empty?}
        items_in_stock.sort
    end

    def affordable
        @inventory.filter_map{|item| item if item[:price] < 50}
    end

    def out_of_stock
        @inventory.filter_map{|item| item if item[:quantity_by_size].empty?}
    end

    def how_much_left(name)
        @inventory.filter_map{|item| item[:quantity_by_size] if item[:name]==name}
    end

    def total_stock
        total = 0
        @inventory.each do |item|
            item[:quantity_by_size].each do |key, value|
                total += value
            end
        end
        total
    end

    attr_accessor :inventory
    
end


inventory = [
    {price: 125.00, name: "Cola", quantity_by_size: {l033: 3, l05: 7, l1: 8, l2: 4}},
    {price: 40.00, name: "Pepsi", quantity_by_size: {}},
    {price: 39.99, name: "Water", quantity_by_size: {l033: 1, l2: 4}},
    {price: 70.00, name: "Juice", quantity_by_size: {l033: 7, l05: 2}}
    ]

shop_inventory = ShopInventory.new(inventory)
puts "item_in_stock:"
puts "#{shop_inventory.item_in_stock}\n\n"
puts "affordable:"
puts "#{shop_inventory.affordable}\n\n"
puts "out_of_stock:"
puts "#{shop_inventory.out_of_stock}\n\n"
puts "how_much_left:"
puts "#{shop_inventory.how_much_left("Cola")}\n\n"
puts "total_stock:"
puts "#{shop_inventory.total_stock}"