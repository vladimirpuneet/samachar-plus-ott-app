acess token : EAAUU87iAsCYBQOLha4ZBFYmZAiqkwQSaBiTNMXDckYY86iSidq3Q5yat3FJRVfZC0QIjuq7d3dkd7w6i2AKdc3DEZC7qwSrbumjrz9eYvEDJ5lBFtFQTh1L63G62dKxhQUAoD6nbymDKp92esBTMZAQhLWlhxwGHx3HAIZBb0cYv9upwrudLLBtl8vjofx1wyvUuSfW7O07dkeEQZAzZAHA9dGXD0ICc07PbEAwtJAPCFpFSDHHVhZCZCCZA0IdRkh1DMVc3xZAV7rA7h9sfeZBXbMiByerY77YcZD

Send and receive messages
Configure how you will send and receive messages from your WhatsApp Business account.
Step 1: Select phone numbers
Test phone numbers allow you to send free messages for 90 days. You can use your own phone number, which is subject to limits and pricing. About pricing
From
From
Test number: +1 555 186 1699
​
Phone number ID: 936621786198953
WhatsApp Business Account ID: 838480668806431

curl -i -X POST \
  https://graph.facebook.com/v22.0/936621786198953/messages \
  -H 'Authorization: Bearer EAAUU87iAsCYBQOLha4ZBFYmZAiqkwQSaBiTNMXDckYY86iSidq3Q5yat3FJRVfZC0QIjuq7d3dkd7w6i2AKdc3DEZC7qwSrbumjrz9eYvEDJ5lBFtFQTh1L63G62dKxhQUAoD6nbymDKp92esBTMZAQhLWlhxwGHx3HAIZBb0cYv9upwrudLLBtl8vjofx1wyvUuSfW7O07dkeEQZAzZAHA9dGXD0ICc07PbEAwtJAPCFpFSDHHVhZCZCCZA0IdRkh1DMVc3xZAV7rA7h9sfeZBXbMiByerY77YcZD' \
  -H 'Content-Type: application/json' \
  -d '{ "messaging_product": "whatsapp", "to": "918800311966", "type": "template", "template": { "name": "hello_world", "language": { "code": "en_US" } } }'