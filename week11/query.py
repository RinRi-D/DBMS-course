from pymongo import MongoClient
import datetime

client = MongoClient("mongodb://localhost")
db = client['test']


def ex1():
    cursor = db.restaurants.find({'cuisine': 'Irish'})
    print(len(list(cursor)))

    cursor = db.restaurants.find({'cuisine': 'Russian'})
    print(len(list(cursor)))

    cursor = db.restaurants.find({
        '$or': [{'cuisine': 'Irish'}, {'cuisine': 'Russian'}]})
    cursor_list = list(cursor)
    print(len(cursor_list))

    cursor = db.restaurants.find({
        'address.building': '284',
        'address.street': 'Prospect Park West',
        'address.zipcode': '11215'})
    print(list(cursor))


def atomic_insert_bestrest():
    bestrest = {
            'address': {
                'building': '126',
                'coord': [-73.9557413, 40.7720266],
                'street': 'Sportivnaya',
                'zipcode': '420500' },
            'borough': 'Innopolis',
            'cuisine': 'Serbian',
            'name': 'The Best Restaurant',
            'restaurant_id': '41712354',
            'grades': [{
                'date': datetime.datetime(2023, 4, 4, 0, 0),
                'grade': 'A',
                'score': 11
                }]
            }

    db.restaurants.delete_many({'restaurant_id': '41712354'})

    db.restaurants.insert_one(bestrest)

    cursor = db.restaurants.find({'restaurant_id': '41712354'})
    print(list(cursor))


def delete_brooklyn1_ThaiN():
    db.restaurants.delete_one({'borough': 'Brooklyn'})
    db.restaurants.delete_many({'cuisine': 'Thai'})


def insert_random_item_for_ex4():
    bestrest = {
            'address': {
                'building': '126',
                'coord': [-73.9557413, 40.7720266],
                'street': 'Prospect Park West',
                'zipcode': '177013' },
            'borough': 'Innopolis',
            'cuisine': 'Serbian',
            'name': 'The Best Restaurant',
            'restaurant_id': '177013123',
            'grades': [{
                'date': datetime.datetime(2023, 4, 4, 0, 0),
                'grade': 'B',
                'score': 11
                }]
            }

    db.restaurants.delete_many({'restaurant_id': '177013123'})

    db.restaurants.insert_one(bestrest)


def ex4():
    cursor = db.restaurants.find({
        'address.street': 'Prospect Park West'
        })
    restaurants = list(cursor)

    for restaurant in restaurants:
        cnt = 0
        for grade in restaurant['grades']:
            if grade['grade'] == 'A':
                cnt = cnt + 1
        
        if cnt >= 1:
            result = db.restaurants.delete_one({'restaurant_id': restaurant['restaurant_id']})
            print(f'Deleted {result.deleted_count} items')
        else:
            result = db.restaurants.update_one(
                    {'restaurant_id': restaurant['restaurant_id']},
                    {'$push': {
                        'grades': {
                            'date': datetime.datetime.utcnow(),
                            'grade': 'A',
                            'score': 11
                            }
                        }})
            print('Modified:')
            print(list(db.restaurants.find({'restaurant_id': restaurant['restaurant_id']})))


def main():
    ex1()
    atomic_insert_bestrest()
    delete_brooklyn1_ThaiN()
    insert_random_item_for_ex4()
    ex4()


if __name__ == "__main__":
    main()
