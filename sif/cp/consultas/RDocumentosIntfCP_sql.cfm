<!---Traducción de campos--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_ConsDocCxP = t.Translate('Tit_ConsDocCxP','Consulta de Documentos de CxP por Interfaz.')>
<cfset LB_SNnumero = t.Translate('LB_SNnumero','N&uacute;mero del Socio')>
<cfset LB_SNRFC = t.Translate('LB_SNRFC','RFC del Socio')>
<cfset LB_SNnombre = t.Translate('LB_SNnombre','Nombre del Socio')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_NumBoleta = t.Translate('LB_FecDoc','Boleta')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_FecDoc = t.Translate('LB_FecDoc','Fecha')>
<cfset LB_Monto = t.Translate('LB_Monto','TOTAL','/sif/generales.xml')>
<cfset LB_subtotal = t.Translate('LB_subtotal','SUBTOTAL','/sif/generales.xml')>
<cfset LB_iva = t.Translate('LB_iva','IVA','/sif/generales.xml')>
<cfset LB_ieps = t.Translate('LB_ieps','IEPS','/sif/generales.xml')>

<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta')>
<cfset LB_NoDatRel = t.Translate('LB_NoDatRel','No hay datos relacionados')>
<cfset LB_NoDocRel = t.Translate('LB_NoDocRel','El n&uacute;mero de Documentos Resultantes')>


<!---Consultas para pintar el formulario--->
<!---Categorias--->
    <cfquery name="rsCPTransacciones" datasource="#Session.DSN#">
    	 select CPTcodigo, CPTdescripcion
    	 from CPTransacciones
    	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <cfif isdefined('form.SNNUMERO') and LEN(TRIM(form.SNNUMERO))>
    	<cfquery name="rsSocio" datasource="#session.DSN#">
    		select *
    		from SNegocios
    		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    		  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
    	</cfquery>
    </cfif>

<!---QUERYS DEL FILTRO--->
    <!---Se obtiene el nombre de la BD de minisif--->
    	<cfquery name="BDMinisif" datasource="#session.DSN#">
            	select DB_NAME() as BD
    	</cfquery>
        <cfset db_minisif = "#BDMinisif.BD#">
    <!---Incia consulta de acuerdo al filtro--->
        <cfquery name="rsIntF10" datasource="sifinterfaces">
    		select 
                ie10.ID,NumeroSocio,SNidentificacion as SNRFC,SNnombre,CodigoTransacion,Documento,
                ie10.NumeroBOL,Odescripcion as Oficina,CONVERT(varchar,FechaDocumento,23) FechaDocumento,
                sum(isnull(importeImpuesto,0)) IVA, 
                sum(isnull(MontoIEPS,0)) IEPS, 
                sum(isnull(precioTotal,0)) SubTotal,
                sum(isnull(importeImpuesto,0))+sum(isnull(MontoIEPS,0))+sum(isnull(precioTotal,0)) MontoTotal,
				convert(money,null) moneynull
    		from IE10 ie10
    			inner join ID10 id10
    			on ie10.ID=id10.ID
                inner join #db_minisif#..Oficinas o 
                on ie10.CodigoOficina=o.Ocodigo
                inner join #db_minisif#..SNegocios sn
                on ie10.NumeroSocio=sn.SNcodigoext
    		where 
            EcodigoSDC=(select EcodigoSDC from #db_minisif#..Empresas emp
						where ie10.EcodigoSDC=emp.EcodigoSDC
						and emp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
            <cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
			    <cfif datecompare(url.FechaIni, url.FechaFin) eq -1>
				    and ie10.FechaDocumento between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#">
			    <cfelseif datecompare(url.FechaIni, url.FechaFin) eq 1>
				    and ie10.FechaDocumento between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#">
			    <cfelseif datecompare(url.FechaIni, url.FechaFin) eq 0>
				    and ie10.FechaDocumento between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#">
			    </cfif>
		    <cfelseif isdefined("url.FechaIni") and len(trim(url.FechaIni))>
			    and ie10.FechaDocumento >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#">
		    <cfelseif isdefined("url.FechaFin") and len(trim(url.FechaFin))>
			    and ie10.FechaDocumento <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#">
		    </cfif>
			<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
				and sn.SNcodigo = #url.fSNcodigo#
			</cfif>
			<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
				and ie10.CodigoTransacion = '#url.CPTcodigo#'
			</cfif>
    		group by ie10.ID,NumeroSocio,SNidentificacion,SNnombre,CodigoTransacion,Documento,ie10.NumeroBOL,Odescripcion,FechaDocumento
        </cfquery>


        <cfquery name="rsIntF10Sum" dbtype="query">
    		select 
                Count(*) TotalRegistros,
                sum(IVA) SumIVA, 
                sum(IEPS) SumIEPS, 
                sum(SubTotal) SumSubTotal,
                sum(MontoTotal) SumMontoTotal,
				Sum(moneynull) moneynull
    		from rsIntF10
        </cfquery>

