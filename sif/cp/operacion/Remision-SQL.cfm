<!--- <cfdump var="#url#">
<cfdump var="#form#"> --->

<!--- 
	Creado por Israel Rodriguez
	Fecha: 25-09-2014
	Motivo: Requerimiento para formar un registro de facturas tomando en cuenta las Remisiones
	
 --->
<cfif isdefined("Form.chk")>
	<cfset pagos = #ListToArray(Form.chk, ',')#>
	<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
		<cfset LvarDetOC = #ListToArray(LvarLin, "|")#>
		<cfset LvarPos1IDdocumento = LvarDetOC[1]>
		<cfset LvarPos2DOlinea = LvarDetOC[2]>
	<!---<cfthrow message="#LvarPos1IDdocumento#  #LvarPos2DOlinea#">--->
    
    <cfquery name="rsRemi" datasource="#session.dsn#">
    	select Cod_Impuesto, Numero_Documento from RemisionesD a
        inner join RemisionesE b on a.Ecodigo=b.Ecodigo  and a.idRemision=b.idRemision
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and a.idDetRem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
    </cfquery>
    <cfset Documento=rsRemi.Numero_Documento>
    <cfif rsRemi.Cod_Impuesto EQ 'IVA0'>
        <cfquery name="rsCMP0" datasource="#session.dsn#">
            select Cid,Cformato from Conceptos 
            where Ecodigo=#session.Ecodigo#
            and Ccodigo ='CMP0' 
        </cfquery>
        <cfif rsCMP0.RecordCount GT 0>
            <cfset Cid=rsCMP0.Cid>
            <cfset Cformato=rsCMP0.Cformato>
        </cfif>
    <cfelse>    
        <cfquery name="rsCMP16" datasource="#session.dsn#">
            select Cid,Cformato from Conceptos 
            where Ecodigo=#session.Ecodigo#
            and Ccodigo ='CMP16' 
        </cfquery>
        <cfif rsCMP16.RecordCount GT 0>
            <cfset Cid=rsCMP16.Cid>
            <cfset Cformato=rsCMP16.Cformato>
        </cfif>
    </cfif>    
    <cfquery name="getCuenta" datasource="#session.dsn#">
        select CFcuenta,CCuenta
        from CFinanciera 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cformato#">    
    </cfquery>
    <cfset CCuenta=getCuenta.CCuenta>
    <cfset CFcuenta=getCuenta.CFcuenta>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into DDocumentosCxP (IDdocumento,  Cid,  Ecodigo,  Ccuenta, CFcuenta, CFid,  DDdescripcion,
              DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Icodigo,  codIEPS,tasaIEPS,DDMontoIEPS,idDetRemision) 
			
				select	#LvarPos1IDdocumento# as IDdocumento,						
						#Cid#,
						a.Ecodigo,
                        #CCuenta#,
						#CFcuenta#,
						1,
						 case when Cod_Impuesto = 'IVA0' then  '#Documento# Compras 0%' when Cod_Impuesto = 'IVA16' then '#Documento#  Compras 16%' end DDescripcion,
						a.Cantidad,
                        a.Precio_Unitario,
						a.Descuento_lin,
						00,
                        a.Total_Lin,
						'S',
						a.Cod_Impuesto,
						a.codIEPS,
                        a.pctjeIEPS,
                        a.montoIEPS,
                        a.idDetRem
				from RemisionesD a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.idDetRem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
				Order by a.ID_Linea
			
		</cfquery>

		<!--- Elimina el descuento si es mayor que el total linea --->
		<cfquery datasource="#session.DSN#">
			update DDocumentosCxP 
			   set DDdesclinea		= 0
			     , DDporcdesclin	= 0
			where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and idDetRemision 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
			  and DDdesclinea 	> DDcantidad * DDpreciou
		</cfquery>
	
						
		<!--- Calcula el total linea --->
		<cfquery datasource="#session.DSN#">
			update DDocumentosCxP 
			   set DDtotallinea		= round(((DDcantidad * DDpreciou)- DDdesclinea) + coalesce(DDMontoIEPS,0),2)
			where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and idDetRemision 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
		</cfquery>
		
		<!------>
		<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
			select coalesce(sum(b.DDtotallinea * d.DIporcentaje / 100.00),0.00) as TotalImpuesto
			from EDocumentosCxP a left outer join DDocumentosCxP b
			  on a.IDdocumento = b.IDdocumento and 
				 a.Ecodigo = b.Ecodigo left outer join Impuestos c
			  on a.Ecodigo = c.Ecodigo and
				 b.Icodigo = c.Icodigo left outer join DImpuestos d
			  on c.Ecodigo = d.Ecodigo and 
				 b.Icodigo = d.Icodigo
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and  c.Icompuesto = 1
		</cfquery>
		<cfquery name="rsTotalImpuesto1" datasource="#session.DSN#">
			select coalesce(sum(b.DDtotallinea * c.Iporcentaje / 100.00),0.00) as TotalImpuesto
			from EDocumentosCxP a left outer join DDocumentosCxP b
			  on a.Ecodigo = b.Ecodigo and
				 a.IDdocumento = b.IDdocumento left outer join Impuestos c
			  on b.Ecodigo = c.Ecodigo and
				 b.Icodigo = c.Icodigo
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and c.Icompuesto = 0
		</cfquery>
		<cfquery name="rsTotal" datasource="#session.DSN#">
			select coalesce(sum(a.DDtotallinea),0.00) as Total
			from DDocumentosCxP a inner join EDocumentosCxP b
			  on a.IDdocumento = b.IDdocumento
			  and a.Ecodigo = b.Ecodigo
			where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
		</cfquery>
		<!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
		<cfquery name="rsUpdateE" datasource="#session.DSN#">
				update EDocumentosCxP 
				set EDimpuesto = round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
						   ,EDtotal = #rsTotal.Total# 
									  + round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
									  -  EDdescuento
			   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cftransaction>
	<!--- 	<cfdump var="#LvarPos1IDdocumento#">
		<cfdump var="#LvarPos2Linea#"> --->
		
	</cfloop>

		<script language="JavaScript" type="text/javascript">
			if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
			window.close();
		</script>
	

</cfif>