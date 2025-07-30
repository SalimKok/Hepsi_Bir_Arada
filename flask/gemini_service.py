import os
from dotenv import load_dotenv
import google.generativeai as genai

# .env dosyasındaki ortam değişkenlerini yükle
load_dotenv()

GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')

# API anahtarını yapılandır
genai.configure(api_key=GEMINI_API_KEY)


def generate_gemini_response(prompt_text):
    try:
        model = genai.GenerativeModel('models/gemini-2.5-flash')

        # İstek gönder ve yanıtı al
        response = model.generate_content(prompt_text)
        return response.text

    except Exception as e:
        print(f"Gemini API'ye istek gönderilirken bir hata oluştu: {e}")
        return "Üzgünüm, isteğinizi şu an işleyemiyorum."   

# Örnek kullanım (Bu kısmı daha sonra API endpoint'inizde çağıracaksınız)
def categorize(str):

    social_media_message = str 

    category_prompt = f"""
    Verilen sosyal medya mesajının içeriğini analiz et ve mesajın en uygun olduğu tek bir kategori seç. Yalnızca kategorinin adını çıktı olarak ver. Eğer mesaj açıkça bu kategorilerden birine girmiyorsa "Diğer" olarak işaretle.

    Kategoriler:
    - Şikayet: Bir problem, memnuniyetsizlik veya kusur belirtiliyorsa.
    - Soru: Bir bilgi talebi veya netlik arayışı varsa.
    - Teşekkür: Bir takdir, memnuniyet veya minnettarlık ifadesi varsa.
    - Öneri: Bir iyileştirme, yeni bir özellik veya fikir sunuluyorsa.
    - Spam: Alakasız reklam, dolandırıcılık girişimi veya istenmeyen tekrar eden içerikse.
    - Diğer: Yukarıdaki kategorilerden hiçbirine uymuyorsa.

    Mesaj: "{social_media_message}"
    """

    # Gemini API'sine isteği gönder ve kategoriyi al
    predicted_category = generate_gemini_response(category_prompt)
    
    print(f"Tahmin Edilen Kategori: {predicted_category.strip()}") # Baştaki/sondaki boşlukları temizleyelim
    return predicted_category.strip()

def suggested_reply(message, category):
    # Spam mesajlarına otomatik cevap üretmek istemediğimiz için basit bir kontrol
    if category.lower() == "spam":
        return "Bu bir spam mesajı, otomatik yanıt oluşturulmayacaktır."

    reply_prompt = f"""
    Sen bir sosyal medya yöneticisisin. Aşağıdaki orijinal mesajı ve belirlenen kategorisini dikkate alarak, kullanıcının mesajına nazik, yardımsever ve 160 karakteri aşmayacak kısa bir yanıt önerisi oluştur. Yalnızca yanıt metnini döndür, başka bir şey ekleme.

    Orijinal Mesaj: "{message}"
    Belirlenen Kategori: "{category}"

    Cevap Önerisi:
    """
    try:
        # API çağrısı, potansiyel olarak hata fırlatabilir
        api_response = generate_gemini_response(reply_prompt)

        # generate_gemini_response fonksiyonundan bir hata mesajı gelirse
        if "ERROR:" in api_response:
            suggested_reply = "API hatası nedeniyle yanıt oluşturulamadı."
        elif not api_response.strip(): # API'den boş veya sadece boşluk içeren bir yanıt gelirse
            suggested_reply = "Geçersiz veya boş yanıt alındı."
        else:
            suggested_reply = api_response.strip()

    except Exception as e:

        if e == 429:
           print("⚠️ API kotasi dolmuş. Daha sonra tekrar deneyin.")
           suggested_reply ="Üzgünüm, günlük yapay zeka kotamı doldurduğum için size daha sonra cevap vereceğim."   
        else:
           print(f"suggested_reply içinde beklenmeyen bir hata oluştu: {e}")
           suggested_reply = "Beklenmeyen bir hata nedeniyle yanıt oluşturulamadı."
    
    print(f"önerilen cevap: {suggested_reply.strip()}")  

    return suggested_reply.strip()