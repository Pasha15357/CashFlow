//
//  Widget1.swift
//  CashFlow
//
//  Created by Паша on 17.05.24.
//

import SwiftUI

struct Widget1: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Зачем вообще экономить и как это делать")
                        .font(.title2)
                        .bold()
                    
                    Text("""
                                        Экономия денег — это не просто процесс накопления средств, но и важный навык, который помогает улучшить ваше финансовое благополучие и уверенность в завтрашнем дне. Умение правильно распоряжаться своими доходами позволяет не только справляться с непредвиденными расходами, но и достигать крупных финансовых целей, будь то покупка жилья, образование или путешествия. В этой статье мы рассмотрим ключевые советы и стратегии, которые помогут вам научиться экономить деньги с умом и получать от этого удовольствие.
                                        """)
                    Image(systemName: "piggybank.fill")
                }
                
                Group {
                    Text("1. Откладывайте деньги сразу после зарплаты")
                        .font(.title2)
                        .bold()
                    
                    Text("""
                    Финансовая подушка безопасности должна быть обязательно. Это первое, ради чего стоит экономить деньги. В идеале неплохо иметь отдельный накопительный счёт: как только зарплата пришла на карту, вы тут же отправляете на этот счёт 10–15% от полученной суммы.
                    Тратить эти деньги и обещать себе, что в следующем месяце вы отложите вдвое больше, нельзя. Во-первых, придётся отправить в фонд накоплений не 15, а уже 30% — почти треть зарплаты. Во-вторых, финансовые дела требуют дисциплины. Раз решили экономить, то никаких отговорок быть не может.
                    """)
                    Image(systemName: "calendar")
                }

                Group {
                    Text("2. Не тяните с оплатой счетов")
                        .font(.title2)
                        .bold()

                    Text("""
                    Предположим, в этом месяце вам очень не хочется платить за коммунальные услуги, потому что и без того есть много идей, как использовать деньги. Сюрприз: в следующем месяце надо будет платить больше. Если затянуть с оплатой, набегает приличная сумма, которая наверняка пробьёт дыру даже в сбалансированном бюджете.
                    Регулярные платежи — следующий пункт в списке того, на что нужно потратить деньги сразу после зарплаты. Отложили средства в фонд накоплений, оплатили всё, что нужно, остальными деньгами распоряжайтесь на своё усмотрение.
                    """)
                    Image(systemName: "banknote")
                }

                Group {
                    Text("3. Составляйте списки покупок")
                        .font(.title2)
                        .bold()

                    Text("""
                    В первую очередь это касается ежедневных походов в супермаркет. Вы ведь наверняка замечали, что заходите в магазин условно за молоком и гречкой, а выходите с пакетами всякой всячины, которая вам прямо сейчас не очень-то и нужна.
                    Чтобы избежать напрасных трат, составьте меню на неделю и сделайте список, в какой день какие продукты вам нужно приобрести. Так будет меньше шансов столкнуться с ситуацией, когда продукты, на которые вы потратили свои кровные, бесславно протухли в глубинах холодильника.
                    """)
                    Image(systemName: "list.bullet")
                }

                Group {
                    Text("4. Следите за скидками")
                        .font(.title2)
                        .bold()

                    Text("""
                    Подпишитесь на информационные рассылки интернет-магазинов, изучайте рекламные листовки в супермаркетах и установите приложение-агрегатор скидок. Времени на поиск самых симпатичных цен уходит не так уж много, а экономия в перспективе может оказаться вполне приличной.
                    Тут есть один важный момент: если речь идёт не о ближайшем магазине, а о гипермаркете на другом конце города, прикиньте, сколько денег вы потратите на дорогу. Стоимость поездки в такси или на своём автомобиле может свести соблазнительную скидку к нулю.
                    """)
                    Image(systemName: "tag.fill")
                }

                Group {
                    Text("5. Обдумывайте приобретения")
                        .font(.title2)
                        .bold()

                    Text("""
                    Прежде всего решите, действительно ли вам нужна эта вещь или просто нашло шальное настроение и приспичило срочно потратить деньги. Подождите хотя бы неделю: если желание приобрести заветную штуку не исчезнет, переходите к поиску самого выгодного варианта. Возможно, в интернете получится найти вещь мечты со скидкой.
                    И точно не стоит отправляться на шопинг в день зарплаты. Пусть у вас в кармане сейчас приличная сумма, но это не означает, что нужно как можно быстрее её спустить. На эти деньги вам ещё жить, да и финансовую подушку безопасности никто не отменял.
                    """)
                    Image(systemName: "cart.fill")
                }

                Group {
                    Text("6. Планируйте крупные траты заранее")
                        .font(.title2)
                        .bold()

                    Text("""
                    Закончились холода — перетряхните тёплую одежду и посмотрите, что можно носить следующей зимой, а что надо обновить, пока идут распродажи. Заодно проверьте, как дела с летним гардеробом, и запишите, что нужно купить к сезону.
                    Такой подход позволяет избежать ситуаций, когда волей-неволей приходится отдавать любые деньги за вещь, которая срочно нужна. Это своего рода налог на беспечность, но никто не заставляет вас его платить.
                    """)
                    Image(systemName: "calendar.badge.clock")
                }

                Group {
                    Text("7. Дёшево не значит плохо")
                        .font(.title2)
                        .bold()

                    Text("""
                    Взять хотя бы продукцию собственных торговых марок гипермаркетов. Как правило, эти вещи дешевле, чем аналогичные товары с громким именем.
                    Ради интереса сравните, сколько стоит банка горошка известной торговой марки и собственного бренда гипермаркета. Качество продукта при этом не страдает, так что можете смело покупать и экономить.
                    """)
                    Image(systemName: "scalemass.fill")
                }

                Group {
                    Text("8. Некоторые вещи выгоднее покупать с рук")
                        .font(.title2)
                        .bold()

                    Text("""
                    Например, праздничную одежду, которую вы вряд ли будете часто носить, детские вещи, музыкальные инструменты и спортивный инвентарь. Бывшие в употреблении гантели ничем не хуже новых, зато обойдутся вам дешевле.
                    И да, вещи, которые вам не нужны, можно продать. Так они принесут людям пользу, а вам немного денег.
                    """)
                    Image(systemName: "hand.thumbsup.fill")
                }

                Group {
                    Text("9. Делите расходы")
                        .font(.title2)
                        .bold()

                    Text("""
                    Например, можно с друзьями делать совместные заказы из интернет-магазинов и делить поровну стоимость доставки. Ещё один вариант — совместные поездки в гипермаркет. Если попадётся акция «Два по цене одного», получится неплохо сэкономить.
                    Наконец, если устраиваете домашнюю вечеринку (что в принципе дешевле похода в бар), разделите покупки. С вас еда, с гостей напитки, или наоборот.
                    """)
                    Image(systemName: "person.2.fill")
                }

                Group {
                    Text("10. Составьте список вещей, на которых нельзя экономить")
                        .font(.title2)
                        .bold()

                    Text("""
                    Экономия должна быть разумной — чрезмерное ограничение в тратах часто приводит к ещё большим расходам. Например, покупка дешёвых ботинок на весну грозит тем, что после первой же прогулки по лужам ботинки дадут течь, а вам придётся тратиться на ремонт или новую пару обуви.
                    Хорошая одежда и обувь, лекарства, свежие продукты — вот минимальный список вещей, за которые стоит заплатить чуть больше. Если получилось найти идеальное сочетание цены и качества — прекрасно, если нет — выбирайте всё же качество.
                    """)
                    Image(systemName: "checkmark.seal.fill")
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    Widget1()
}
