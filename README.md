# open-falcon-scripts
1. 定时把graph库中的endpoint和endpoint_counter同步到auto_aggr库
2. 用触发器的方式实现同上的功能
3. 以上两种方式目的都是一样的，只不过多一次保证
4. 以上所有的目的，是为了实现open-falcon自动生成cluster给aggregator汇聚。这是其中一环。auto_host程序会定时一分钟来读取auto_aggr里面的新数据，根据数据生成cluster.
5. 实际上只用2就可以了
