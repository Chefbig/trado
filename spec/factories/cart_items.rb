FactoryGirl.define do
    factory :cart_item do
        sequence(:price) { |n| n }
        sequence(:quantity) { |n| n }
        sequence(:weight) { |n| n }

        association :sku
        association :cart

        factory :accessory_cart_item do
            after(:create) do |cart_item, evaluator|
                create(:cart_item_accessory, cart_item: cart_item)
            end
        end

        factory :update_cart_item_quantity do
            quantity 5
            after(:create) do |cart_item, evaluator|
                create(:cart_item_accessory, quantity: 5, cart_item: cart_item)
            end
        end

        factory :update_cart_item_weight do
            weight BigDecimal.new("13.5")
            after(:create) do |cart_item, evaluator|
                accessory = create(:accessory, weight: BigDecimal.new("2.5"))
                create(:cart_item_accessory, cart_item: cart_item, accessory: accessory)
            end
        end
    end
end