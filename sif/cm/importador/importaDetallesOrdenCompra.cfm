
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsImportador" datasource="#session.dsn#">
select * from #table_name#
</cfquery>
<!---<cf_dump var="#rsImportador#">--->

<cfset idOC = Session.ImportarDetalleOC.idOC>

<cfquery name="rsEnc" datasource="#session.dsn#">
	select * from EOrdenCM
    where EOidorden=#idOC# 
    and Ecodigo=#session.Ecodigo#
</cfquery>

<cfloop query="rsImportador">
<cfset tipoOC=#rsImportador.CMtipo#>

<cfquery name="check1" datasource="#session.dsn#">
	select count(1) as check1 from  CFuncional
    where Ecodigo=#session.Ecodigo#
    and CFcodigo=<cfqueryparam value="#rsImportador.CFcodigo#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif check1.check1 EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El Centro Funcional no se encuentra registrado en el sistema(#CFcodigo#)!')
		</cfquery>
	</cfif>

<cfif tipoOC EQ "S">
  Validar si ya existe el codigo de Servicio en el sistema 
	<cfquery name="check2" datasource="#session.dsn#">
		select count(1) as check2
		from #table_name# a,
		Conceptos b
		where a.Ccodigo = b.Ccodigo
		and b.Ecodigo = #session.Ecodigo#
		and b.Ccodigo='#rsImportador.Ccodigo#'
	</cfquery>	
	<cfif check2.check2 EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El servicio no se encuentra registrado en el sistema(#Ccodigo#)!')
		</cfquery>
	</cfif>

	<!--- Validar existencia de Unidades --->
		<cfquery name="check3" datasource="#session.dsn#">
			  select count(1) as check3
			   from #table_name# a
			   where ltrim(rtrim(a.Ucodigo)) <>''
				 and a.Ucodigo is not null
				 and a.Ucodigo='#rsImportador.Ucodigo#'
				 and not exists( select 1 from Unidades b
									   where b.Ucodigo = a.Ucodigo
										  and b.Ecodigo =  #session.Ecodigo#)
				and a.Ccodigo='#Ccodigo#'
			</cfquery>
		<cfif check3.check3 gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Codigo de Unidad no esta registrado en el sistema(#check3.Ucodigo#)!')
			</cfquery>
		</cfif>
</cfif>

<cfif tipoOC EQ "A"> 
	<cfquery datasource="#session.DSN#" name="rsAlmacen">
        select count(1) as check4, b.Aid
        from #table_name# a,Almacen b
        where b.Ecodigo= #session.Ecodigo# 
              and b.Almcodigo=a.Almcodigo 
        	  and b.Almcodigo='#rsImportador.Almcodigo#' 
        group by b.Aid       
	</cfquery>
    
    <cfif rsAlmacen.check4 EQ 0>
    	<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Codigo de Almacen no esta registrado en el sistema(#Almcodigo#)!')
		</cfquery>
    </cfif>
    <cfquery datasource="#session.DSN#" name="rsArticulo">
    	select count(1) as check5, Aid
        from Articulos
        where Ecodigo= #session.Ecodigo#
        and Acodigo='#rsImportador.Acodigo#'
        group by Aid
    </cfquery>
    
    <cfif rsArticulo.check5 EQ 0>
        <cfquery name="ERR" datasource="#session.DSN#">
                    insert into #errores# (Error)
                    values ('Error!Codigo de Articulo no esta registrado en el sistema(#Acodigo#)!')
        </cfquery>
    </cfif>    
</cfif>		
	
</cfloop>

		<cfquery name="rsErr" datasource="#session.dsn#">
			select count(1) as cantidad from #errores#
		</cfquery>
		
		<cfif rsERR.cantidad eq 0>
        <!---<cfthrow message="Error ">--->
        
        
        <cfquery name="consecutivod" datasource="#session.DSN#">
			select max(DOconsecutivo) as linea
			from DOrdenCM
			where EOidorden = <cfqueryparam value="#idOC#" cfsqltype="cf_sql_numeric">
		</cfquery>
        <cfset linea = 0>
		<cfif consecutivod.RecordCount gt 0  and len(consecutivod.linea)>
			<cfset linea = consecutivod.linea >
        </cfif>
        <cfdump var ="#linea#">
        <cfif rsImportador.RecordCount gt 0 >
            <cfloop query="rsImportador">		
                <cfset linea =linea + 1 >
                <cfquery name="rsConServ" datasource="#session.dsn#">
                    select Cid from Conceptos where Ccodigo = '#rsImportador.Ccodigo#' and Ecodigo =#session.Ecodigo#
                </cfquery>
                <cfquery name="rsCFuncional" datasource="#session.dsn#">
                    select  CFid from  CFuncional
                    where Ecodigo=#session.Ecodigo#
                    and CFcodigo=<cfqueryparam value="#rsImportador.CFcodigo#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <!---Porcentaje de Impuesto--->
                <cfquery datasource="#session.dsn#" name="rsImpuestoP">
                    select Iporcentaje, Icreditofiscal
                    from Impuestos
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.Icodigo#">
                </cfquery>	
                <cfquery name="rsIns" datasource="#session.dsn#">		
                    insert into DOrdenCM ( Ecodigo, EOidorden, EOnumero, DOconsecutivo,   
                                           CMtipo, Cid, Aid, Alm_Aid, DOdescripcion, DOobservaciones, DOalterna, 
                                           DOcantidad, DOcantsurtida, DOpreciou, DOtotal, 
                                           DOmontodesc, DOporcdesc, DOfechaes, DOgarantia, 
                                           CFid, Icodigo, Ucodigo, DOfechareq, Ppais, 
                                           DOimpuestoCosto, DOimpuestoCF)
                             values (   <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">, 
                                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Replace(idOC,',','','all')#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Replace(rsEnc.EOnumero,',','','all')#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#linea#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#rsImportador.CMtipo#">,
                                        <cfif rsImportador.CMtipo eq "S" and ( len(trim(rsConServ.Cid)) gt 0 and rsConServ.Cid neq "-1")><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(rsConServ.Cid,',','','all')#"><cfelse>null</cfif>, 
                                        <cfif rsImportador.CMtipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(rsArticulo.Aid,',','','all')#"><cfelse>null</cfif>,
                                        <cfif rsImportador.CMtipo eq "A"><cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Replace(rsAlmacen.Aid,',','','all')#"><cfelse>null</cfif>,
                                        
                                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#rsImportador.DOdescripcion#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#rsImportador.DOobservaciones#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsImportador.DOalterna#" voidnull>,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Replace(rsImportador.DOcantidad,',','','all')#">, 
                                        0, 
                                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(rsImportador.DOpreciou,',','','all')#">, 
                                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(rsImportador.DOpreciou,',','','all')*Replace(rsImportador.DOcantidad,',','','all')#">, 
                                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Replace(rsImportador.DODescuento,',','','all')#">,  
                                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#(Replace(rsImportador.DODescuento,',','','all')*100)/(Replace(rsImportador.DOpreciou,',','','all')*Replace(rsImportador.DOcantidad,',','','all'))#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(rsImportador.DOfechaes)#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_integer"		value="#Replace(rsImportador.DOgarantia,',','','all')#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Replace(rsCFuncional.CFid,',','','all')#">,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(rsImportador.Icodigo)#" voidnull>,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#trim(rsImportador.Ucodigo)#" voidnull>,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp"	value="#rsImportador.DOfechareq#" voidnull>,
                                        <cf_jdbcquery_param cfsqltype="cf_sql_char"	    	value="#rsImportador.Ppais#" voidnull>,
                                        <cfif rsImpuestoP.Icreditofiscal EQ 0>
                                            <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#((Replace(rsImportador.DOpreciou,',','','all')*Replace(rsImportador.DOcantidad,',','','all'))-Replace(rsImportador.DODescuento,',','','all'))*(rsImpuestoP.Iporcentaje/100)#">,
                                            0  
                                        <cfelse>
                                            0,
                                            <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#((Replace(rsImportador.DOpreciou,',','','all')*Replace(rsImportador.DOcantidad,',','','all'))-Replace(rsImportador.DODescuento,',','','all'))*(rsImpuestoP.Iporcentaje/100)#">
                                        </cfif>                                        
                                    )
                </cfquery>
            </cfloop>
        
            <cfquery name="rsTotal" datasource="#session.DSN#">
                select sum(round(DOtotal-DOmontodesc+DOimpuestoCosto+DOimpuestoCF,2)) as total,
                       sum(round(DOimpuestoCosto+DOimpuestoCF,2)) as impuesto,
                       sum(round(DOmontodesc,2)) as Descuento
                from EOrdenCM a
                    inner join DOrdenCM b
                    on a.EOidorden=b.EOidorden
                where a.EOidorden = <cfqueryparam value="#idOC#" cfsqltype="cf_sql_numeric">
            </cfquery>    
        
            <cfquery name="update" datasource="#session.DSN#">
                update EOrdenCM
                set EOtotal	  = <cf_jdbcquery_param value="#rsTotal.total#" cfsqltype="cf_sql_money">,
                Impuesto = <cf_jdbcquery_param value="#rsTotal.impuesto#" cfsqltype="cf_sql_money">,
                EOdesc = <cf_jdbcquery_param value="#rsTotal.Descuento#" cfsqltype="cf_sql_money">
                where EOidorden = <cf_jdbcquery_param value="#idOC#" cfsqltype="cf_sql_numeric">
            </cfquery>
		</cfif>					  
				 
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>		 
		
					
  
							
	