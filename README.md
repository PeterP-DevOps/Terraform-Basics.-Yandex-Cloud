# Домашнее задание к занятию «Основы Terraform. Yandex Cloud» - Петр Петров

### Задание 1.
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git. Убедитесь что ваша версия Terraform ~>1.12.0

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. service_account_key_file.
3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
5. Подключитесь к консоли ВМ через ssh и выполните команду  curl ifconfig.me. Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address". Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: eval $(ssh-agent) && ssh-add Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
6. Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.
В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

### Решение 1.

```
╷
│ Error: Error while requesting API to create instance: client-request-id = 0f1e2a14-2d67-451a-946c-09f89144a4b7 client-trace-id = 74fae66d-356e-4e90-84ad-17cd2fd8b878 rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```

Ошибка Platform "standart-v4" not found возникает из‑за опечатки в названии платформы — standart-v4, но правильное название в Yandex Cloud — standard-v4  

```
╷
│ Error: Error while requesting API to create instance: client-request-id = 3ce97dc0-7676-4561-89ec-96ac6209ae9c client-trace-id = 325c96cd-35e8-4816-8886-4e6ced4bcdf3 rpc error: code = FailedPrecondition desc = Platform "standard-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {

```

Ошибка означает, что в yandex_compute_instance указан platform_id = "standard-v4", но для нашего облака/зоны такой платформы нет или она не поддерживается в текущем каталоге/фолдере.
Надо замненить standard-v4 на доступную платформу: standard-v3 или standard-v2.


```
╷
│ Error: Error while requesting API to create instance: client-request-id = 7632af78-3312-4c4e-8bea-29c02355758e client-trace-id = 138bce31-62ab-499a-b416-898e6fe23cd5 rpc error: code = InvalidArgument desc = the specified core fraction is not available on platform "standard-v3"; allowed core fractions: 20, 50, 100
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```

Ошибка означает, что в конфигурации Terraform для виртуальной машины указана **доля vCPU (core_fraction), которая не поддерживается платформой standard-v3.  

5. Скриншот из ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес:  

![скриншот](pic/1.png)

скриншот консоли, curl должен отобразить тот же внешний ip-адрес:  
![скриншот](pic/2.png)

6. Параметры preemptible = true и core_fraction = 5 позволяют сэкономить до 80 % бюджета за счёт использования прерываемых ВМ и оптимизировать затраты для нетребовательных задач   

### Задание 2.

1. Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
3. Проверьте terraform plan. Изменений быть не должно.

### Решение 2.

![скриншот](pic/3.png)

### Задание 3.
1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: "netology-develop-platform-db" , cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом vm_db_ в том же файле ('vms_platform.tf'). ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

### Решение 3.

![скриншот](pic/4.png)

### Задание 4.
1. Объявите в файле outputs.tf один output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.
В качестве решения приложите вывод значений ip-адресов команды terraform output.

### Решение 4.

![скриншот](pic/5.png)

### Задание 5.
1. В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

### Решение 5.

![скриншот](pic/6.png)

### Задание 6.
1. Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в единую map-переменную vms_resources и внутри неё конфиги обеих ВМ в виде вложенного map(object).  

```
пример из terraform.tfvars:
vms_resources = {
  web={
    cores=2
    memory=2
    core_fraction=5
    hdd_size=10
    hdd_type="network-hdd"
    ...
  },
  db= {
    cores=2
    memory=4
    core_fraction=20
    hdd_size=10
    hdd_type="network-ssd"
    ...
  }
}
```
2. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.  

```
пример из terraform.tfvars:
metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
}
```

3. Найдите и закоментируйте все, более не используемые переменные проекта.  
4. Проверьте terraform plan. Изменений быть не должно.  

### Решение 6

![скриншот](pic/7.png)
