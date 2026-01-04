// Local cache for state and district names
// This avoids repeated database calls for geographic data
// Cache is populated with exact fields from live database schema
import { supabase } from '../services/supabaseClient';

export interface StateCache {
  id: string;
  state_code: number;
  state_name_english: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface DistrictCache {
  id: string;
  state_id: string;
  district_code: number | null;
  district_name_english: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

// Cache populated with only enabled (is_active = true) states and districts
// Data structure matches the live database schema exactly
let STATES_CACHE: StateCache[] = [
  {
    id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    state_code: 9,
    state_name_english: 'Uttar Pradesh',
    is_active: true,
    created_at: '2025-11-20T13:30:43.456889+00:00',
    updated_at: '2025-11-20T13:30:43.456889+00:00'
  },
  {
    id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    state_code: 5,
    state_name_english: 'Uttarakhand',
    is_active: true,
    created_at: '2025-11-20T13:30:43.456889+00:00',
    updated_at: '2025-11-20T13:30:43.456889+00:00'
  }
];

let DISTRICTS_CACHE: DistrictCache[] = [
  {
    id: '5ad8198c-1baf-486d-bdc9-eee23feba284',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 118,
    district_name_english: 'Agra',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '8f42cd51-d145-45a0-a94d-7169acab9320',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 119,
    district_name_english: 'Aligarh',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b733deb8-4b33-4677-9d0e-662faac5749d',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 45,
    district_name_english: 'Almora',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '965acd19-6183-4398-a694-e43b3192a4c8',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 121,
    district_name_english: 'Ambedkar Nagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'f3af55fb-f1a9-46de-a418-2fc9ae5ac624',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 640,
    district_name_english: 'Amethi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '56bc8c24-0a57-4f0a-bcd0-84c256a1c684',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 154,
    district_name_english: 'Amroha',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'ec477435-0bcb-430f-9af5-08dc31d5fe45',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 122,
    district_name_english: 'Auraiya',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '4a1a553c-9537-4e81-a0a9-adf4f5a11833',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 140,
    district_name_english: 'Ayodhya',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'cdedb3aa-48ee-4d92-97c4-4e843ac564fc',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 123,
    district_name_english: 'Azamgarh',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '8e9322aa-bfa8-43ad-9cc5-39ef8cdab404',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 46,
    district_name_english: 'Bageshwar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'f4767466-e06b-4d86-a721-0fb2fe609e3a',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 124,
    district_name_english: 'Baghpat',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'ded8027d-7137-417d-b8f7-a6f04e88ba43',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 125,
    district_name_english: 'Bahraich',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '6ca841ec-d4d5-4e64-92b8-9851265fceee',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 126,
    district_name_english: 'Ballia',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '81bd2aba-4484-4612-8f96-6a93c088d7f8',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 127,
    district_name_english: 'Balrampur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '8f98b5b3-0568-44aa-8176-d2240c3313f4',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 128,
    district_name_english: 'Banda',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'cff48747-4fa3-49e3-853a-e7335a9811b7',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 129,
    district_name_english: 'Bara Banki',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '80a0d023-89b7-4c73-8aab-1603ac30f21d',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 130,
    district_name_english: 'Bareilly',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '93cc112e-77ed-42dd-804e-1c8a5a4d7ffd',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 131,
    district_name_english: 'Basti',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b69738c3-f2c6-40c9-953b-e86b9054dafd',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 179,
    district_name_english: 'Bhadohi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '291e8ac6-4059-4652-9df5-8ea006598760',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 132,
    district_name_english: 'Bijnor',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '9fcf587d-7157-4b18-9468-e9fd8d229215',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 133,
    district_name_english: 'Budaun',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b7ca8ac6-c6c5-45d1-85cc-0e89bc90ec05',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 134,
    district_name_english: 'Bulandshahr',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b49da715-0017-4860-aa8d-8d087d0d72fd',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 47,
    district_name_english: 'Chamoli',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'd6e5a25c-ffd0-4059-b0ff-c8d92d8cb835',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 48,
    district_name_english: 'Champawat',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'e89b4c77-b1b0-4879-a139-60f655efea6f',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 135,
    district_name_english: 'Chandauli',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b0683aa8-6c38-4c2f-b5f1-f7607b9b8c10',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 136,
    district_name_english: 'Chitrakoot',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '5c4a1b94-4668-47be-b9b5-0c437b57b782',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 49,
    district_name_english: 'Dehradun',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '9cfd6908-4350-4d15-bfe4-e9702e2dd3c8',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 137,
    district_name_english: 'Deoria',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '46cbb19a-d5f9-4c83-aa1a-9137bf213ba3',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 138,
    district_name_english: 'Etah',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'cf262332-a047-47f6-af44-834d2be00710',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 139,
    district_name_english: 'Etawah',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '0e897eb3-9ec2-468e-abad-13d90bbf03c6',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 141,
    district_name_english: 'Farrukhabad',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'c47920b9-4ad3-43c1-ac3d-5d767ace0468',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 142,
    district_name_english: 'Fatehpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '92915bd0-4e36-485a-802b-4b28283f1abf',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 143,
    district_name_english: 'Firozabad',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '992fc981-c175-429b-b543-00d1f5ca7bb4',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 144,
    district_name_english: 'Gautam Buddha Nagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'e5c4c7c3-96f5-4c62-805d-7b470007b176',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 145,
    district_name_english: 'Ghaziabad',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '4f5d8cd1-1fff-4b48-82c3-4f083c4b2160',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 146,
    district_name_english: 'Ghazipur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '26a1d58a-8f2c-44cb-bf0e-cfa85503889e',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 147,
    district_name_english: 'Gonda',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'bf572a40-d204-461f-aa2e-428b56a9b0cd',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 148,
    district_name_english: 'Gorakhpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b29f5745-a2a0-4f76-905e-2a445706d609',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 149,
    district_name_english: 'Hamirpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'f39d49d0-c2bd-4492-a496-ebf13f1ec033',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 661,
    district_name_english: 'Hapur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '0cef1b86-386c-4b1a-9a65-062e1123b114',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 150,
    district_name_english: 'Hardoi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '069edd84-9662-4b71-b2fd-792c809eca74',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 50,
    district_name_english: 'Haridwar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'a0173d2c-39dd-43fb-9378-6ba0a99e149e',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 163,
    district_name_english: 'Hathras',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '5d6bbf5b-67ab-4dc7-b63a-632c7aa2599d',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 151,
    district_name_english: 'Jalaun',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '20dc4385-e311-4696-a6ae-83f7fa4fa698',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 152,
    district_name_english: 'Jaunpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '068e23b2-c9b6-45cd-b262-2415ebe748fc',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 153,
    district_name_english: 'Jhansi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '9e4eba98-f934-4b6f-9213-6bcb5d528fc1',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 155,
    district_name_english: 'Kannauj',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'a236d754-4a04-4930-9cc4-088a4c7e75d8',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 156,
    district_name_english: 'Kanpur Dehat',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b3f5c6bd-bdce-453f-a59b-3161560bb473',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 157,
    district_name_english: 'Kanpur Nagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'a79994b2-b515-4040-b741-ecc58ab3d398',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 633,
    district_name_english: 'Kasganj',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'bb2d948c-3907-44b6-9c33-15105bedbe4b',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 158,
    district_name_english: 'Kaushambi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '3c20c844-72b5-454a-b981-a4aa6bd4ce6c',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 159,
    district_name_english: 'Kheri',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '0c893def-1c07-446b-b88d-e0d292236814',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 160,
    district_name_english: 'Kushinagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'ba8686ae-c320-4299-a491-c2bfbd441385',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 161,
    district_name_english: 'Lalitpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '961de6d4-8498-486b-996e-dec1c9711606',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 162,
    district_name_english: 'Lucknow',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'ff3eb283-218b-427b-8cac-138d9aededb1',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 165,
    district_name_english: 'Mahoba',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '45069ef2-2d02-46b6-8a45-a555865e6bc0',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 164,
    district_name_english: 'Mahrajganj',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'd121a5b5-f5e0-4891-aede-d8c050e8446d',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 166,
    district_name_english: 'Mainpuri',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '15ec1812-0563-47a9-8f2b-4d063eeab821',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 167,
    district_name_english: 'Mathura',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '270cd8e8-d345-4c1e-a644-340388c06e4e',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 168,
    district_name_english: 'Mau',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '0af95029-8e4d-4e8b-92bb-7db86fa83e05',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 169,
    district_name_english: 'Meerut',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '570d911c-74ab-4711-b4bb-5759b8e19179',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 170,
    district_name_english: 'Mirzapur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'a6a5fa47-2374-43eb-bf94-6a1ebaa12187',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 171,
    district_name_english: 'Moradabad',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '863ea65b-95bd-4278-93c5-6b8ea4090b76',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 172,
    district_name_english: 'Muzaffarnagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'c22b9f4a-78fd-4851-85d0-d51599e06fc1',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 51,
    district_name_english: 'Nainital',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '87048707-f9e0-4b77-ab0e-a5f40c05968e',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 52,
    district_name_english: 'Pauri Garhwal',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'c213829a-68ed-45e9-8dca-edeefa2a6e57',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 173,
    district_name_english: 'Pilibhit',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '6bba9aca-c50e-4686-9a3f-b253ad7424fb',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 53,
    district_name_english: 'Pithoragarh',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '865cd915-9bd5-4d1f-aff8-c393757e09a0',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 174,
    district_name_english: 'Pratapgarh',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '4a518568-182b-49d8-b1bd-c2d3029943dc',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 120,
    district_name_english: 'Prayagraj',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b408a5e3-c30c-4019-ac6b-d6144ceac900',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 175,
    district_name_english: 'Rae Bareli',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '4bed8566-f2d6-4100-b6f7-a54e24e1748b',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 176,
    district_name_english: 'Rampur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '0f75224b-551c-40ea-a646-155b26298cb3',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 54,
    district_name_english: 'Rudra Prayag',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '519768a0-8576-4cb9-abda-ea16ebf04f31',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 177,
    district_name_english: 'Saharanpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '17f3e508-727a-4d8c-96e1-34f1583e8389',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 659,
    district_name_english: 'Sambhal',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '236b75de-4175-411d-ae21-301eaa39008e',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 178,
    district_name_english: 'Sant Kabir Nagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '818d4b3d-ef9c-4da0-8c8c-5d491d8df774',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 180,
    district_name_english: 'Shahjahanpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'cbf79346-3cb9-46d4-a335-bbd4633fa193',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 660,
    district_name_english: 'Shamli',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'e673ebad-9660-46d9-a8b1-0235bcec41d3',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 181,
    district_name_english: 'Shrawasti',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'b3c8869b-2904-4be7-afd7-f849b720961b',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 182,
    district_name_english: 'Siddharthnagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'f2c0be8d-f295-4c20-bc26-65c041d1588b',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 183,
    district_name_english: 'Sitapur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '95a437e6-35b4-445a-84e1-e3d2cee16295',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 184,
    district_name_english: 'Sonbhadra',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'a5986473-1ce8-4a20-b065-fe10a50ba5e0',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 185,
    district_name_english: 'Sultanpur',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '96811236-1c62-4052-bee4-9692ae1a9d9c',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 55,
    district_name_english: 'Tehri Garhwal',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'df205b9d-d879-4532-8e45-4ce417b09115',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 56,
    district_name_english: 'Udam Singh Nagar',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: 'cd09fbd4-a93e-4937-a498-583ba0acfe13',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 186,
    district_name_english: 'Unnao',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '7735a929-e067-49fd-8632-71d9762c8889',
    state_id: 'eddf04d0-86cd-4b2b-b3d3-9902f366c78c',
    district_code: 57,
    district_name_english: 'Uttar Kashi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  },
  {
    id: '50fc1abd-7195-4384-bdc5-512ed7170f26',
    state_id: 'edb2c3a5-ce92-4ead-8241-af0229af9296',
    district_code: 187,
    district_name_english: 'Varanasi',
    is_active: true,
    created_at: '2025-11-20T13:31:02.843517+00:00',
    updated_at: '2025-11-20T13:31:02.843517+00:00'
  }
];

/**
 * Get state name from cache by ID
 */
export function getStateNameById(stateId: string): string {
  const state = STATES_CACHE.find(s => s.id === stateId);
  return state ? state.state_name_english : 'N/A';
}

/**
 * Get district name from cache by ID
 */
export function getDistrictNameById(districtId: string): string {
  const district = DISTRICTS_CACHE.find(d => d.id === districtId);
  return district ? district.district_name_english : 'N/A';
}

/**
 * Get state ID from cache by name (for backward compatibility)
 */
export function getStateIdByName(stateName: string): string | null {
  const state = STATES_CACHE.find(s => s.state_name_english === stateName);
  return state ? state.id : null;
}

/**
 * Get district ID from cache by name (for backward compatibility)
 */
export function getDistrictIdByName(districtName: string): string | null {
  const district = DISTRICTS_CACHE.find(d => d.district_name_english === districtName);
  return district ? district.id : null;
}

/**
 * Initialize or update the cache (would be called during app startup or when needed)
 * In a real implementation, this would fetch from the database
 */
export async function initializeGeographicCache() {
  try {
    // Fetch active states from database
    const { data: states, error: statesError } = await supabase
      .from('states')
      .select('*')
      .eq('is_active', true);

    if (statesError) {
      console.error('Error fetching states:', statesError);
      return;
    }

    // Fetch active districts from database
    const { data: districts, error: districtsError } = await supabase
      .from('districts')
      .select('*')
      .eq('is_active', true);

    if (districtsError) {
      console.error('Error fetching districts:', districtsError);
      return;
    }

    // Update cache arrays
    STATES_CACHE.length = 0; // Clear existing cache
    STATES_CACHE.push(...(states || []));

    DISTRICTS_CACHE.length = 0; // Clear existing cache
    DISTRICTS_CACHE.push(...(districts || []));

    console.log(`Geographic cache initialized with ${STATES_CACHE.length} states and ${DISTRICTS_CACHE.length} districts`);
  } catch (error) {
    console.error('Error initializing geographic cache:', error);
  }
}

/**
 * Add or update a state in the cache
 */
export function addStateToCache(state: StateCache): void {
  const index = STATES_CACHE.findIndex(s => s.id === state.id);
  if (index >= 0) {
    STATES_CACHE[index] = state;
  } else {
    STATES_CACHE.push(state);
  }
}

/**
 * Add or update a district in the cache
 */
export function addDistrictToCache(district: DistrictCache): void {
  const index = DISTRICTS_CACHE.findIndex(d => d.id === district.id);
  if (index >= 0) {
    DISTRICTS_CACHE[index] = district;
  } else {
    DISTRICTS_CACHE.push(district);
  }
}

/**
 * Get all states from cache
 */
export function getAllStates(): StateCache[] {
  return [...STATES_CACHE];
}

/**
 * Get all districts from cache
 */
export function getAllDistricts(): DistrictCache[] {
  return [...DISTRICTS_CACHE];
}

/**
 * Get districts for a specific state from cache
 */
export function getDistrictsForState(stateId: string): DistrictCache[] {
  return DISTRICTS_CACHE.filter(d => d.state_id === stateId);
}