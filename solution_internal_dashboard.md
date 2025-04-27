
#  خطوات حل مشكلة Unreachable Internal Dashboard

## 1. التحقق من حل DNS

- التحقق من إعدادات DNS:
  ```bash
  cat /etc/resolv.conf
  ```
- اختبار حل الدومين بالسيرفر الافتراضي:
  ```bash
  dig internal.example.com
  ```
- اختبار حل الدومين باستخدام Google DNS (8.8.8.8):
  ```bash
  dig @8.8.8.8 internal.example.com
  ```



---

## 2. التحقق من وصول الخدمة

- اختبار الوصول للبورت 80 و443:
  ```bash
  telnet <resolved_ip> 80
  telnet <resolved_ip> 443
  ```
- استخدام curl للتأكد من الرد:
  ```bash
  curl -v http://internal.example.com
  curl -v https://internal.example.com
  ```
- التحقق من الخدمات اللي شغالة على السيرفر:
  ```bash
  ss -tulnp | grep ':80\|:443'
  ```




## 3. تحليل الأسباب المحتملة

 مشاكل في DNS  إعدادات خاطئة أو السيرفر مش بيرد 
 مشاكل شبكة أو فايروول حظر الاتصال أو مشكلة Routing
 الخدمة مش شغالة  الخدمة وقعت أو مش مستجيبة 
 خطأ في إعدادات السيرفر  Misconfiguration في Nginx أو Apache 
 مشكلة في ملف hosts  Conflict في /etc/hosts أو CNAME record 


## 4. تنفيذ الحلول

- تعديل إعدادات DNS:
  ```bash
  sudo nano /etc/resolv.conf
  # أضف:
  nameserver 8.8.8.8
  nameserver 8.8.4.4
  ```

- إعادة تشغيل خدمة systemd-resolved:
  ```bash
  sudo systemctl restart systemd-resolved
  sudo resolvectl status
  ```

- فحص اتصال الشبكة:
  ```bash
  ping <resolved_ip>
  traceroute <resolved_ip>
  ```

- مراجعة وإدارة الفايروول:
  ```bash
  sudo iptables -L
  sudo firewall-cmd --list-all
  ```

- فحص حالة خدمة الويب:
  ```bash
  systemctl status nginx
  systemctl status apache2
  ```
- إعادة تشغيل الخدمة:
  ```bash
  sudo systemctl restart nginx
  sudo systemctl restart apache2
  ```

- مراجعة اللوجات:
  ```bash
  sudo journalctl -xe
  sudo cat /var/log/nginx/error.log
  sudo cat /var/log/apache2/error.log
  ```


---

## 5. إضافة مدخل محلي لتجاوز DNS

- تعديل ملف `/etc/hosts`:
  ```bash
  sudo nano /etc/hosts
  ```
- أضف السطر:
  ```
  <resolved_ip> internal.example.com
  ```

- التحقق بعد التعديل:
  ```bash
  ping internal.example.com
  curl http://internal.example.com
  ```


---

## 6. تثبيت إعدادات DNS بشكل دائم

- باستخدام systemd-resolved:
  ```bash
  sudo systemctl restart systemd-resolved
  sudo resolvectl status
  ```

- باستخدام NetworkManager:
  ```bash
  nmcli con modify "connection_name" ipv4.dns "8.8.8.8 8.8.4.4"
  nmcli con up "connection_name"
  ```


