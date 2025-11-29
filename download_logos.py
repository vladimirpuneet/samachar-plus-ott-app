#!/usr/bin/env python3
import urllib.request
import os
import hashlib

# Channel logos to download
logos = {
    'live-1': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0FgBSdI4TYVJyvq_QgXyb75TEeiszKJm6LQ&s',
    'live-2': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF2Y0RVCUCiSZTkvIn_O8KIVQKzIGxn8pV4Q&s',
    'live-3': 'https://th-i.thgim.com/public/latest-news/wtrkwx/article68081322.ece/alternates/FREE_1200/DDNews.jpg',
    'live-4': 'https://upload.wikimedia.org/wikipedia/commons/2/24/News_18_India.png',
    'live-5': 'https://images.seeklogo.com/logo-png/46/2/ndtv-india-logo-png_seeklogo-466899.png',
    'live-6': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNJxr9YJ_5R0AxpVM_xfGzpfobuyshYKPHAg&s',
    'live-7': 'https://yt3.googleusercontent.com/QCKjEhgbRnhNTcPeTe5-uAYnLyf0OdDpYPZSgLufVeOi1LTygW2XIli33YXGohWphxWlAQRVCQ=s900-c-k-c0x00ffffff-no-rj',
    'live-8': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE5yq5kFO48XWr25bAp1Y4xF-UGmg5OXJ6qQ&s',
    'live-9': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRupx5hp2GkJ1hoFX1rc4omoTuLJeKp7_b2EO9qfJspAha-FH2-s8AKsr1wyIkPauvz8Rs&usqp=CAU',
    'live-10': 'https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/66/92/9d/66929dd4-5268-ad97-9b65-f7f1bfee8417/AppIcon-0-0-1x_U007epad-0-85-220.png/1200x630wa.png',
    'live-11': 'https://upload.wikimedia.org/wikipedia/en/thumb/a/a6/TV9_Bharatvarsh.svg/250px-TV9_Bharatvarsh.svg.png',
    'live-46': 'https://i.ibb.co/jZPg3HXW/tn-navbharat.jpg',
    'live-12': 'https://images.seeklogo.com/logo-png/60/2/wion-logo-png_seeklogo-605806.png',
    'live-13': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDY3XZpruzPEg5YPKa2o6_fFAoNhtJWq8JJw&s',
    'live-14': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKV89B5gUlXtUNUJ9J_1m_Ahxod9kO71XyYw&s',
    'live-15': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwjUVJCJlJaaUtIBnHE3njLdKcdWlcALk_tQ&s',
    'live-16': 'https://content.jdmagicbox.com/comp/kolkata/84/033p520084/catalogue/times-now-circus-avenue-kolkata-news-satellite-channels-9xcseqhba6.jpg',
    'live-17': 'https://jiotv.catchup.cdn.jio.com/dare_images/images/Republic_TV.png',
    'live-18': 'https://webcast.gov.in/assets/images/RajyaSabha.png',
    'live-19': 'https://i.ibb.co/PZ9RmJmd/dd-india.jpg',
    'live-20': 'https://media.assettype.com/bloombergquint/2023-12/d55e2378-26a1-42ee-8d02-7ab53846081d/ndtv_profit.png?w=1200&h=675&auto=format%2Ccompress&fit=max&enlarge=true',
    'live-21': 'https://yt3.googleusercontent.com/sxHEe-On1euLaHO6gssZiJXWQpRgjy7duGBWC9qPmDEul_AfSvthGaGOc3uRZEhTUchMBEOJlp0=s900-c-k-c0x00ffffff-no-rj',
    'live-22': 'https://jiotvimages.cdn.jio.com/dare_images/images/CNBC_Awaaz.png',
    'live-31': 'https://yt3.googleusercontent.com/5S4SubzzRn25zCq2FNyrGjVgZhjHI536Ld41nAwMGQKvgrndOpDp8yhqKe1ZLg-y67YMYqAB=s900-c-k-c0x00ffffff-no-rj',
    'live-32': 'https://yt3.googleusercontent.com/H_G4mPfQH5xJWZgrqfOYg-fOSABfRpyErqhnV4WpV7NI3VnhJPY1mRuDZLcxwvHzLKTOXgsqYw=s900-c-k-c0x00ffffff-no-rj',
    'live-33': 'https://upload.wikimedia.org/wikipedia/commons/3/3a/News18_Bihar_Jharkhand.png',
    'live-34': 'https://yt3.googleusercontent.com/Y8aFJxC0NMZbPDFfGfRLr1ymVHgujMpnbdzUrMEv8M3KWFt7EmgCgA17T4f5AsKCKzVdK1tBhQ=s900-c-k-c0x00ffffff-no-rj',
    'live-35': 'https://yt3.googleusercontent.com/xIJSgMJGzG1RMformQj_mdyl0Xf9wihKmpPpTmXsVDjH2S_pp80OcITIL8HVL8ZuxsnbqtJVxzg=s160-c-k-c0x00ffffff-no-rj',
    'live-36': 'https://yt3.googleusercontent.com/qf5BdXxgdMXutHsPx7Y9QH-EFfhA-8hkHNPPbYtMfj9SQWyQxEjlq4EYUtdmn52zQ5mUwG29dg=s900-c-k-c0x00ffffff-no-rj',
    'live-37': 'https://yt3.googleusercontent.com/Tc7Ad0aVG60qoHUKbCu8bK9t6gRBZvSPauIDEIYhadkUHnT9r9hp-Q38aRYkkjYRgWJaHP-EbA=s900-c-k-c0x00ffffff-no-rj',
    'live-39': 'https://yt3.googleusercontent.com/yTIy-oADsKUGbdR92P3exxP-2HpRNbxvQtz6En_2bJ1pyIgfw400ibfNErg0SXBsVGKAU1FCRA=s900-c-k-c0x00ffffff-no-rj',
    'live-40': 'https://yt3.googleusercontent.com/CqBwhwPCfGMMlZK1L0Sluelx6cA-RqN5nEZb2Uihy8JZupeU-12Gfyvw93o53SgOHpnBBW4xXkg=s900-c-k-c0x00ffffff-no-rj',
    'live-41': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDqiaSpRM5Jl8ejnLl1H3VoNUWvWvjdo3XUw&s',
}

output_dir = 'assets/images/channels'
os.makedirs(output_dir, exist_ok=True)

for channel_id, url in logos.items():
    try:
        # Determine file extension
        ext = '.png'
        if url.endswith('.jpg') or 'jpg' in url.lower():
            ext = '.jpg'
        
        output_path = os.path.join(output_dir, f'{channel_id}{ext}')
        
        print(f'Downloading {channel_id}...')
        urllib.request.urlretrieve(url, output_path)
        print(f'  ✓ Saved to {output_path}')
    except Exception as e:
        print(f'  ✗ Error downloading {channel_id}: {e}')

print('\nDone!')
