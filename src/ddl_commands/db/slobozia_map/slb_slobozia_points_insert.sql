insert into slb_slobozia_points (
   osm_id,
   poi_name,
   category,
   sub_category,
   longitude,
   latitude,
   geom
)
   (
      select jt.elem_id,
             nvl(
                jt.elem_tags_name,
                'No Name'
             ),
             case
                when jt.elem_tags_amenity is not null then
                   'amenity'
                when jt.elem_tags_shop is not null then
                   'shop'
                when jt.elem_tags_leisure is not null then
                   'leisure'
                when jt.elem_tags_tourism is not null then
                   'tourism'
                when jt.elem_tags_healthcare is not null then
                   'healthcare'
                when jt.elem_tags_office is not null then
                   'office'
                when jt.elem_tags_historic is not null then
                   'historic'
                when jt.elem_tags_railway in ( 'station',
                                               'stop' )
                    or jt.elem_tags_public_transport in ( 'station',
                                                          'platform',
                                                          'stop_position' )
                    or jt.elem_tags_highway = 'bus_stop' then
                   'transport'
                else
                   'other'
             end,
             coalesce(
                jt.elem_tags_amenity,
                jt.elem_tags_shop,
                jt.elem_tags_leisure,
                jt.elem_tags_tourism,
                jt.elem_tags_healthcare,
                jt.elem_tags_office,
                jt.elem_tags_historic,
                case
                      when jt.elem_tags_railway in('station',
                                                   'stop') then
                         'railway_' || jt.elem_tags_railway
                      when jt.elem_tags_public_transport in('station',
                                                            'platform',
                                                            'stop_position') then
                         'public_transport_' || jt.elem_tags_public_transport
                      when jt.elem_tags_highway = 'bus_stop' then
                         'bus_stop'
                end
             ),
             jt.elem_lon,
             jt.elem_lat,
             mdsys.sdo_geometry(
                2001,
                8307,
                mdsys.sdo_point_type(
                   jt.elem_lon,
                   jt.elem_lat,
                   null
                ),
                null,
                null
             )
        from stg_osm_map s,
             json_table ( s.payload,'$.elements[*]'
                columns (
                   elem_type varchar2 ( 10 ) path '$.type',
                   elem_id number path '$.id',
                   elem_lon number path '$.lon',
                   elem_lat number path '$.lat',
                   elem_tags_name varchar2 ( 200 char ) path '$.tags.name',
                   elem_tags_amenity varchar2 ( 100 ) path '$.tags.amenity',
                   elem_tags_shop varchar2 ( 100 ) path '$.tags.shop',
                   elem_tags_leisure varchar2 ( 100 ) path '$.tags.leisure',
                   elem_tags_tourism varchar2 ( 100 ) path '$.tags.tourism',
                   elem_tags_healthcare varchar2 ( 100 ) path '$.tags.healthcare',
                   elem_tags_office varchar2 ( 100 ) path '$.tags.office',
                   elem_tags_historic varchar2 ( 100 ) path '$.tags.historic',
                   elem_tags_railway varchar2 ( 100 ) path '$.tags.railway',
                   elem_tags_public_transport varchar2 ( 100 ) path '$.tags.public_transport',
                   elem_tags_highway varchar2 ( 100 ) path '$.tags.highway'
                )
             )
          jt
       where jt.elem_type = 'node'
         and ( ( jt.elem_tags_amenity is not null )
          or ( jt.elem_tags_shop is not null )
          or ( jt.elem_tags_leisure is not null )
          or ( jt.elem_tags_tourism is not null )
          or ( jt.elem_tags_healthcare is not null )
          or ( jt.elem_tags_office is not null )
          or ( jt.elem_tags_historic is not null )
          or ( jt.elem_tags_railway in ( 'station',
                                         'stop' ) )
          or ( jt.elem_tags_public_transport in ( 'station',
                                                  'platform',
                                                  'stop_position' ) )
          or ( jt.elem_tags_highway = 'bus_stop' ) )
   );

commit;