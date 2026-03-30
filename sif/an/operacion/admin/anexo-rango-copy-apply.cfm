<cfparam name="form.AnexoId" type="numeric">
<cfparam name="form.src_r1" type="integer">
<cfparam name="form.src_r2" type="integer">
<cfparam name="form.src_c1" type="integer">
<cfparam name="form.src_c2" type="integer">

<cfparam name="form.dst_r1" type="integer">
<cfparam name="form.dst_r2" type="integer">
<cfparam name="form.dst_c1" type="integer">
<cfparam name="form.dst_c2" type="integer">

<cfparam name="form.mod_con" default="">
<cfparam name="form.sel_con">
<cfparam name="form.mod_mes" default="">
<cfparam name="url.sel_mes_modo" default="R">
<cfparam name="url.sel_mes_rel"  default="0">
<cfparam name="url.sel_mes_fijo" default="1">
<cfparam name="url.sel_ano_fijo"  default="0">

<cfparam name="form.mod_ANubica" default="">
<cfparam name="form.ANubicaTipo"	default="-1">
<cfparam name="form.ANubicaEcodigo"	default="-1">
<cfparam name="form.ANubicaOcodigo"	default="-1">
<cfparam name="form.ANubicaGEid"	default="-1">
<cfparam name="form.ANubicaGOid"	default="-1">

<cfparam name="form.sel_Hojasrc">
<cfparam name="form.sel_Hojadst">


<cftransaction action="begin">

    <cfquery datasource="#session.dsn#">
        delete from AnexoCelD
        where AnexoCelId in (
            select AnexoCelId
            from AnexoCel dst
            where dst.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
              and dst.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_Hojadst#">
              and dst.AnexoFila    between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_r1#">
                                   and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_r2#">
              and dst.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_c1#">
                                   and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_c2#"> )
    </cfquery>
    
    <cfquery datasource="#session.dsn#">
        insert into AnexoCelD
            ( AnexoCelId, Ecodigo, AnexoCelFmt, AnexoCelMov, AnexoSigno, BMUsucodigo, Anexolk, Cmayor, PCDcatid )
        select
            dst.AnexoCelId,
            srcd.Ecodigo,
            srcd.AnexoCelFmt, srcd.AnexoCelMov,
            srcd.AnexoSigno,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
            srcd.Anexolk, srcd.Cmayor, srcd.PCDcatid
        from AnexoCel src, AnexoCel dst, AnexoCelD srcd
        where src.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
          and src.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_Hojasrc#">
          
          and dst.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
          and dst.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_Hojadst#">
    
          and src.AnexoFila    between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r1#">
                               and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r2#">
          and src.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c1#">
                               and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c2#">
          and dst.AnexoFila    between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_r1#">
                               and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_r2#">
          and dst.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_c1#">
                               and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_c2#">
          and src.AnexoFila    - dst.AnexoFila    = 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_r1 - form.dst_r1 #">
          and src.AnexoColumna - dst.AnexoColumna = 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_c1 - form.dst_c1 #">
          and srcd.AnexoCelId = src.AnexoCelId
    </cfquery>
    
    <cfquery datasource="#session.dsn#">
        update AnexoCel 
        set 
		<cfif form.mod_con eq 1>
	        AnexoCon =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.sel_con#">,
		</cfif>
		<cfif form.mod_mes eq 1>
	        AnexoRel = 	<cfqueryparam cfsqltype="cf_sql_bit" value="#form.sel_mes_modo EQ 'R'#">,
			<cfif trim(form.sel_mes_modo) EQ 'R'>
	        	AnexoMes = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.sel_mes_rel#">,
				AnexoPer = 	0,
			<cfelse>
	        	AnexoMes = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.sel_mes_fijo#">,
				AnexoPer = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.sel_ano_fijo#">,
			</cfif>
        </cfif> 
		<cfif form.mod_ANubica eq 1>
			Ecodigocel 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANubicaEcodigo#" 	null="#Form.ANubicaTipo eq "GE" OR Form.ANubicaTipo eq ""#">,
			Ocodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANubicaOcodigo#" 	null="#Form.ANubicaTipo neq "O"#">,
			GEid	 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANubicaGEid#" 		null="#Form.ANubicaTipo neq "GE"#">,
			GOid	 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANubicaGOid#" 		null="#Form.ANubicaTipo neq "GO"#">,
		</cfif>        
        
        AVid =  coalesce((select src.AVid 
                from AnexoCel src 
                where src.AnexoId = AnexoCel.AnexoId 
                  and src.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_Hojasrc#"> 
                  and src.AnexoFila between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r1#">
                                    and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r2#">
                  and src.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c1#">
                                       and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c2#">
                  and src.AnexoFila - AnexoCel.AnexoFila = <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_r1 - form.dst_r1 #">
                  and src.AnexoColumna - AnexoCel.AnexoColumna = <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_c1 - form.dst_c1 #">
                  ), AVid), 
        
        
        AnexoES = coalesce((select src.AnexoES                
                    from AnexoCel src 
                    where src.AnexoId = AnexoCel.AnexoId 
                      and src.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_Hojasrc#"> 
                      and src.AnexoFila between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r1#">
                                        and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r2#">
                      and src.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c1#">
                                           and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c2#">
                      and src.AnexoFila - AnexoCel.AnexoFila = <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_r1 - form.dst_r1 #">
                      and src.AnexoColumna - AnexoCel.AnexoColumna = <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_c1 - form.dst_c1 #">
            ), AnexoES), 
        
        AnexoNeg = coalesce((select src.AnexoNeg         
                    from AnexoCel src 
                    where src.AnexoId = AnexoCel.AnexoId 
                      and src.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_Hojasrc#"> 
                      and src.AnexoFila between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r1#">
                                        and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_r2#">
                      and src.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c1#">
                                           and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.src_c2#">
                      and src.AnexoFila - AnexoCel.AnexoFila = <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_r1 - form.dst_r1 #">
                      and src.AnexoColumna - AnexoCel.AnexoColumna = <cfqueryparam cfsqltype="cf_sql_numeric" value="# form.src_c1 - form.dst_c1 #">
            ), AnexoNeg), 
        
        AnexoFor = null
        where AnexoCel.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
             and AnexoCel.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sel_hojadst#">
             and AnexoCel.AnexoFila between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_r1#">
                                    and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_r2#">
             and AnexoCel.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_c1#">
                                       and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dst_c2#">
    </cfquery>
    <cftransaction action="commit"/>    
</cftransaction>

<cflocation url="anexo.cfm?tab=2&AnexoId=# URLEncodedFormat(form.AnexoId) #">

