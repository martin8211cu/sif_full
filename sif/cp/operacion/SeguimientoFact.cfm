<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento") and len(trim(url.IDdocumento))>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cf_templateheader title="Seguimiento de Facturas">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Seguimiento de Facturas'>
		<cfif isdefined("url.Filtro_factura") and len(trim(url.Filtro_factura))>
			<cfset form.Filtro_factura = url.Filtro_factura>
		</cfif>					

		<cfif isdefined("url.filtro_descripcion") and len(trim(url.filtro_descripcion))>
			<cfset form.filtro_descripcion = url.filtro_descripcion>
		</cfif>					
	
		<cfif isdefined("url.filtro_proveedor") and len(trim(url.filtro_proveedor))>
			<cfset form.filtro_proveedor = url.filtro_proveedor>
		</cfif>			
		
		<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
			<cfset form.filtro_fecha = url.filtro_fecha>
		</cfif>	
		
		<cfif isdefined("url.filtro_monto") and len(trim(url.filtro_monto))>
			<cfset form.filtro_monto = url.filtro_monto>
		</cfif>	
		<cfif isdefined("url.filtro_moneda") and len(trim(url.filtro_moneda))>
			<cfset form.filtro_moneda = url.filtro_moneda>
		</cfif>	
		
		<cfif isdefined("url.Filtro_FechasMayores") and len(trim(url.Filtro_FechasMayores))>
			<cfset form.Filtro_FechasMayores = url.Filtro_FechasMayores>
		</cfif>	
	
			<cfquery name="rsLista" datasource="#session.dsn#">
				select x.Ecodigo, x.CPTcodigo,  x.Ddocumento as factura, x.SNcodigo,  es.FTfolio as folio, es.FTidEstado as FTidEstado, es.FTdescripcion as des_estado, c.CPTdescripcion as descripcion, b.SNnombre as proveedor,x.Dfecha as fecha,x.Dtotal as monto,m.Miso4217  as moneda
				 from HEDocumentosCP x
					inner join SNegocios b
						on b.SNcodigo = x.SNcodigo
						and b.Ecodigo = x.Ecodigo
					inner join CPTransacciones c
					 	on c.CPTcodigo = x.CPTcodigo
						and c.Ecodigo = x.Ecodigo
						and c.CPTtipo = 'C'
					inner join Monedas m
						on m.Mcodigo = x.Mcodigo
					left outer join EstadoFact es
						on es.FTidEstado = x.EVestado
				where x.Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.Filtro_factura')and len(trim(form.Filtro_factura)) >
						and upper(x.Ddocumento) like upper('%#form.Filtro_factura#%')
					</cfif>	
					
					<cfif isdefined('form.filtro_descripcion')and len(trim(form.filtro_descripcion)) >
						and upper(c.CPTdescripcion ) like upper('%#form.filtro_descripcion#%')
					</cfif>	
					
					<cfif isdefined('form.filtro_proveedor')and len(trim(form.filtro_proveedor)) >
						and upper(b.SNnombre) like upper('%#form.filtro_proveedor#%')
					</cfif>	
					
					<cfif isdefined('form.filtro_fecha')and len(trim(form.filtro_fecha))  and not isdefined ('form.Filtro_FechasMayores')>
						and x.Dfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.filtro_fecha)#"> 
					</cfif>	
					
					<cfif isdefined('form.filtro_monto')and len(trim(form.filtro_monto)) >
						and x.Dtotal = #form.filtro_monto#
					</cfif>
					
					<cfif isdefined('form.filtro_moneda')and len(trim(form.filtro_moneda)) >
						and upper(m.Miso4217) like upper('%#form.filtro_moneda#%')
					</cfif>	
					
					<cfif isdefined('form.Filtro_FechasMayores')and len(trim(form.Filtro_FechasMayores)) >
						and x.Dfecha > <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.filtro_fecha)#">
					</cfif>	
			
			union all
				select  a.Ecodigo, a.CPTcodigo,  a.EDdocumento as factura, a.SNcodigo, es.FTfolio as folio,es.FTidEstado as FTidEstado, es.FTdescripcion as des_estado,c.CPTdescripcion as descripcion, b.SNnombre as proveedor,a.EDfecha as fecha,a.EDtotal as monto,m.Miso4217 as moneda
				from EDocumentosCxP a
					inner join SNegocios b
						on b.SNcodigo = a.SNcodigo
						and b.Ecodigo = a.Ecodigo
					inner join CPTransacciones c
						on c.CPTcodigo = a.CPTcodigo
						and c.Ecodigo = a.Ecodigo
						and c.CPTtipo = 'C'
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo
					left outer join EstadoFact es
						on es.FTidEstado = a.EVestado
				where a.Ecodigo = #session.Ecodigo#
					<cfif isdefined('form.Filtro_factura')and len(trim(form.Filtro_factura)) >
						and upper(a.EDdocumento) like upper('%#form.Filtro_factura#%')
					</cfif>	
					
					<cfif isdefined('form.filtro_descripcion')and len(trim(form.filtro_descripcion)) >
						and upper(c.CPTdescripcion ) like upper('%#form.filtro_descripcion#%')
					</cfif>	
					
					<cfif isdefined('form.filtro_proveedor')and len(trim(form.filtro_proveedor)) >
						and upper(b.SNnombre) like upper('%#form.filtro_proveedor#%')
					</cfif>	
					
					<cfif isdefined('form.filtro_fecha')and len(trim(form.filtro_fecha)) and not isdefined ('form.Filtro_FechasMayores')>
						and a.EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.filtro_fecha)#"> 
					</cfif>	
					
					<cfif isdefined('form.filtro_monto')and len(trim(form.filtro_monto)) >
						and a.EDtotal = #form.filtro_monto#
					</cfif>	
			
					<cfif isdefined('form.filtro_moneda')and len(trim(form.filtro_moneda)) >
						and upper(m.Miso4217) like upper('%#form.filtro_moneda#%')
					</cfif>	
					
					<cfif isdefined('form.Filtro_FechasMayores')and len(trim(form.Filtro_FechasMayores)) >
						and a.EDfecha > <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.filtro_fecha)#">
					</cfif>	
					and (a.EVestado <> 1 or a.EVestado is not null)
					and es.FTidEstado <> 1
				order by fecha desc
			</cfquery>

			 <table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td style="vertical-align:top" width="100%">
						 <cf_navegacion name="descripcion" 	default="" 	navegacion="navegacion">
						 <cf_navegacion name="proveedor" default="" 	navegacion="navegacion">
						 <cf_navegacion name="fecha" 		default="" 	navegacion="navegacion">
		
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="rsLista"
							query="#rsLista#"
							desplegar="factura, descripcion, proveedor,fecha,monto,moneda"
							etiquetas="Factura, Descripción, Proveedor, Fecha, Monto, Moneda"
							formatos="S,S,S,D,S,S"
							align="left,left,left,left,left,left"
							ajustar="S"
							irA="SeguimientoFact_form.cfm"
							keys="Ecodigo,CPTcodigo,factura,SNcodigo"
							maxrows="30"
							pageindex="3"
							navegacion="#navegacion#" 				 
							showEmptyListMsg= "true"
							checkboxes= "N"
							usaAJAX = "no"
							mostrar_filtro= "true"
							/>
					 </td>
				  </tr>
			 </table>
    <cf_web_portlet_end>
<cf_templatefooter>

