create
    database quanlyvattu;

use
    quanlyvattu;

create table Material
(
    id            int primary key auto_increment,
    material_code int,
    m_name        varchar(20),
    unit_type     varchar(10),
    unit_price    float
);

create table Stock
(
    id                  int primary key auto_increment,
    material_id         int,
    initial_amount      int,
    import_amount       int,
    total_export_amount int,
    foreign key (material_id) references Material (id)
);

create table Supplier
(
    id            int primary key auto_increment,
    supplier_code int,
    supplier_name varchar(50),
    address       varchar(50),
    phone_number  varchar(10)
);

create table Orders
(
    id          int primary key auto_increment,
    order_code  int,
    order_date  DATE,
    supplier_id int,
    foreign key (supplier_id) references Supplier (id)
);

create table ImportSheet
(
    id                int primary key auto_increment,
    import_sheet_code int,
    import_date       DATE,
    order_id          int,
    foreign key (order_id) references Orders (id)
);

create table ExportSheet
(
    id                int primary key auto_increment,
    export_sheet_code int,
    export_date       DATE,
    customer_name     varchar(50)
);

create table OrderDetail
(
    id          int primary key auto_increment,
    order_id    int,
    material_id int,
    quantity    int,
    foreign key (order_id) references Orders (id),
    foreign key (material_id) references Material (id)
);

create table ImportSheetDetail
(
    id                int primary key auto_increment,
    import_sheet_id   int,
    material_id       int,
    quantity          int,
    import_unit_price float,
    note              longtext,
    foreign key (import_sheet_id) references ImportSheet (id),
    foreign key (material_id) references Material (id)
);

create table ExportSheetDetail
(
    id                int primary key auto_increment,
    export_sheet_id   int,
    material_id       int,
    quantity          int,
    export_unit_price float,
    note              longtext,
    foreign key (export_sheet_id) references ExportSheet (id),
    foreign key (material_id) references Material (id)
);

insert into Material
values (null, 101, 'steel', 'meters', 100);
insert into Material
values (null, 102, 'brick', 'thousands', 50);
insert into Material
values (null, 103, 'paint', 'buckets', 30);
insert into Material
values (null, 104, 'sand', 'hrd-kgs', 40);
insert into Material
values (null, 105, 'wood', 'm3', 20);

alter table stock
    change import_amount total_import_amount int;

alter table stock
    add constraint unique (material_id);

insert into Stock
values (null, 1, null, null, null);
insert into Stock
values (null, 2, null, null, null);
insert into Stock
values (null, 3, null, null, null);
insert into Stock
values (null, 4, null, null, null);
insert into Stock
values (null, 5, null, null, null);

insert into supplier
values (null, 201, 'A', 'Thai Binh', null);
insert into supplier
values (null, 202, 'B', 'Ha Noi', null);
insert into supplier
values (null, 203, 'C', 'Nam Dinh', null);

insert into Orders
values (null, 1, '2023-05-14', 1);
insert into Orders
values (null, 2, '2023-05-15', 1);
insert into Orders
values (null, 3, '2023-05-16', 2);

insert into ImportSheet
values (null, 1, '2023-05-14', 1);
insert into ImportSheet
values (null, 2, '2023-05-15', 2);
insert into ImportSheet
values (null, 3, '2023-05-16', 3);

insert into ExportSheet
values (null, 1, '2023-06-14', 'A');
insert into ExportSheet
values (null, 2, '2023-06-15', 'B');
insert into ExportSheet
values (null, 3, '2023-06-16', 'C');

insert into OrderDetail
values (null, 1, 2, 5);
insert into OrderDetail
values (null, 1, 3, 6);
insert into OrderDetail
values (null, 2, 4, 1);
insert into OrderDetail
values (null, 2, 2, 3);
insert into OrderDetail
values (null, 2, 3, 6);
insert into OrderDetail
values (null, 3, 5, 2);

insert into ImportSheetDetail
values (null, 1, 5, 2, 70, null);
insert into ImportSheetDetail
values (null, 2, 2, 5, 60, null);
insert into ImportSheetDetail
values (null, 2, 3, 6, 50, null);
insert into ImportSheetDetail
values (null, 3, 4, 1, 50, null);
insert into ImportSheetDetail
values (null, 3, 2, 3, 60, null);
insert into ImportSheetDetail
values (null, 3, 3, 6, 40, null);

insert into ExportSheetDetail
values (null, 1, 1, 5, 70, null);
insert into ExportSheetDetail
values (null, 2, 2, 6, 60, null);
insert into ExportSheetDetail
values (null, 3, 3, 3, 50, null);
insert into ExportSheetDetail
values (null, 1, 4, 4, 50, null);
insert into ExportSheetDetail
values (null, 2, 5, 2, 60, null);
insert into ExportSheetDetail
values (null, 3, 4, 4, 40, null);

create view vw_CTPNHAP
as
select ImportSheetDetail.id,
       ImportSheetDetail.material_id,
       ImportSheetDetail.quantity,
       ImportSheetDetail.import_unit_price,
       to_import_money
from ImportSheetDetail
         join (select id, quantity, import_unit_price, (quantity * import_unit_price) as to_import_money
               from ImportSheetDetail) as to_import_money
              using (id);

create view vw_CTPNHAP_VT
as
select ImportSheetDetail.id,
       ImportSheetDetail.material_id,
       Material.m_name,
       ImportSheetDetail.quantity,
       ImportSheetDetail.import_unit_price,
       to_import_money
from ImportSheetDetail
         left join Material on Material.id = material_id
         join (select id as new_id, quantity, import_unit_price, (quantity * import_unit_price) as to_import_money
               from ImportSheetDetail) as to_import_money
              on new_id = ImportSheetDetail.id;

create view vw_CTPNHAP_VT_PN
as
select ImportSheetDetail.id,
       ImportSheet.import_date,
       ImportSheet.order_id,
       ImportSheetDetail.material_id,
       Material.m_name,
       ImportSheetDetail.quantity,
       ImportSheetDetail.import_unit_price,
       to_import_money
from ImportSheetDetail
         left join ImportSheet on ImportSheetDetail.import_sheet_id = ImportSheet.id
         left join Material on Material.id = material_id
         join (select id as new_id, quantity, import_unit_price, (quantity * import_unit_price) as to_import_money
               from ImportSheetDetail) as to_import_money
              on new_id = ImportSheetDetail.id;

create view vw_CTPNHAP_VT_PN_DH
as
select ImportSheetDetail.id,
       ImportSheet.import_date,
       ImportSheet.order_id,
       Orders.supplier_id,
       ImportSheetDetail.material_id,
       Material.m_name,
       ImportSheetDetail.quantity,
       ImportSheetDetail.import_unit_price,
       to_import_money
from ImportSheetDetail
         left join ImportSheet on ImportSheetDetail.import_sheet_id = ImportSheet.id
         left join Orders on ImportSheet.order_id = Orders.id
         left join Material on Material.id = material_id
         join (select id as new_id, quantity, import_unit_price, (quantity * import_unit_price) as to_import_money
               from ImportSheetDetail) as to_import_money
              on new_id = ImportSheetDetail.id;

create view vw_CTPNHAP_loc
as
select ImportSheetDetail.id,
       ImportSheetDetail.material_id,
       ImportSheetDetail.quantity,
       ImportSheetDetail.import_unit_price,
       to_import_money
from ImportSheetDetail
         join (select id, quantity, import_unit_price, (quantity * import_unit_price) as to_import_money
               from ImportSheetDetail) as to_import_money
              using (id)
where ImportSheetDetail.quantity > 5;

create view vw_CTPNHAP_VT_loc
as
select ImportSheetDetail.id,
       ImportSheetDetail.material_id,
       Material.m_name,
       ImportSheetDetail.quantity,
       ImportSheetDetail.import_unit_price,
       to_import_money
from ImportSheetDetail
         left join Material on Material.id = material_id
         join (select id as new_id, quantity, import_unit_price, (quantity * import_unit_price) as to_import_money
               from ImportSheetDetail) as to_import_money
              on new_id = ImportSheetDetail.id
where Material.unit_type = 'buckets';

create view vw_CTPXUAT
as
select e.export_sheet_id, e.material_id, e.quantity, e.export_unit_price, to_export_price
from ExportSheetDetail e
         left join (select e.id, e.quantity, e.export_unit_price, (e.quantity * e.export_unit_price) as to_export_price
                    from ExportSheetDetail e) as to_export_price
                   using (id);

create or replace view vw_CTPXUAT_VT
as
select e.export_sheet_id,
       e.material_id,
       M.m_name,
       e.quantity,
       e.export_unit_price
from ExportSheetDetail e
         left join Material M on M.id = e.material_id;

create view vw_CTPXUAT_VT_PX
as
select e.export_sheet_id,
       e.material_id,
       M.m_name,
       e.quantity,
       e.export_unit_price
from ExportSheetDetail e
         left join Material M on M.id = e.material_id;

create view vw_CTPXUAT_VT_PX
as
select e.export_sheet_id,
       ES.customer_name,
       e.material_id,
       M.m_name,
       e.quantity,
       e.export_unit_price
from ExportSheetDetail e
         left join ExportSheet ES on ES.id = e.export_sheet_id
         left join Material M on M.id = e.material_id;

delimiter //
create procedure GetInStock(m_id int)
begin
    select (s.initial_amount + s.total_import_amount - s.total_export_amount) as in_stock
    from Stock s
    where s.material_id = m_id;
end //
delimiter ;

delimiter //
create procedure GetTotalExportMoney(m_id int)
begin
    select sum(e.quantity * e.export_unit_price) as total_export_money
    from ExportSheetDetail e
    group by e.material_id
    having e.material_id = m_id;
end //
delimiter ;

delimiter //
create procedure GetTotalQuantityByOrder(o_id int)
begin
    select sum(o.quantity)
    from OrderDetail o
    group by o.order_id
    having o.order_id = o_id;
end //
delimiter ;

delimiter //
create procedure InsertAnOrder(o_code int, o_date DATE, s_id int)
begin
    insert into Orders values (null, o_code, o_date, s_id);
end //
delimiter ;

delimiter //
create procedure InsertAnOrderDetail(o_id int, m_id int, quan int)
begin
    insert into OrderDetail values (null, o_id, m_id, quan);
end //
delimiter ;