<!---------
	Modificado por: Ana Villavicencio
	Fecha: 20 de julio del 2005
	Motivo:	se modifico la llamada del componente de listas agregando un nuevo parametro 
			para mostrar el total general.
	Línea: 48
	
----------->
<cfset navegacion = "">
<cfif isdefined("form.idDocumentoNeteo")>
	<cfset navegacion = navegacion & "&idDocumentoNeteo=#form.idDocumentoNeteo#">
</cfif>

<cfset LB_SubTit = t.Translate('LB_SubTit','Lista de Documentos a Netear CXP')>   
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Neteo1.xml')>   
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','Neteo1.xml')>   
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Noseha = t.Translate('LB_Noseha',' -- No se ha agregado ningun documento -- ','Neteo1.xml')>
<cfset LB_AntEfe = t.Translate('LB_AntEfe','(ANTICIPO EFECTIVO)')>   
<cfset LB_FavorSFE= t.Translate('LB_FavorSFE','(a favor Sin Flujo Efectivo)')>   

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<cf_dbfunction name="op_concat" returnvariable="_CAT">
		<cfquery name="rslistacxc" datasource="#session.dsn#">
			select 
				case when
					d.CPTtipo = 'D'
					and (
							select count(1)
							  from DDocumentosCP det
							 where det.IDdocumento	= c.IDdocumento
						) = 0 then 1 
					when d.CPTtipo = 'D' then 2
					else 3
				end as ANTs,
				e.SNnombre, d.CPTcodigo, 
				c.Ddocumento, 
				d.CPTcodigo #_CAT# ': ' #_CAT# d.CPTdescripcion #_CAT#
				case 
					when d.CPTtipo = 'D'
					and (
							select count(1)
							  from DDocumentosCP det
							 where det.IDdocumento	= c.IDdocumento
						) = 0 then ' #LB_AntEfe#' 
					when d.CPTtipo = 'D' then ' #LB_FavorSFE#'
						else ' (a pagar)'
				end as CPTdescripcion,

				a.idDocumentoNeteo, b.idDetalle, b.idDocumento, c.Ddocumento, 
				case CPTtipo when 'C' then c.EDsaldo else c.EDsaldo * -1 end as EDsaldo, 
				case CPTtipo when 'C' then b.Dmonto else b.Dmonto * -1 end as Dmonto, 
				CPTtipo, e.SNnombre,
				r.Rcodigo as RcodigoCxC, r.Rporcentaje
			from DocumentoNeteo a
				inner join DocumentoNeteoDCxP b
					inner join EDocumentosCP c
						inner join CPTransacciones d
						on d.CPTcodigo = c.CPTcodigo
						and d.Ecodigo =c.Ecodigo
					left join Retenciones r
						on r.Ecodigo = c.Ecodigo
						and r.Rcodigo = c.Rcodigo
					inner join SNegocios e 
						on e.SNcodigo = c.SNcodigo
						and e.Ecodigo = c.Ecodigo
					on c.IDdocumento = b.idDocumento 	
					and c.CPTcodigo = b.CPTcodigo
				on b.idDocumentoNeteo = a.idDocumentoNeteo
			where a.idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
			 and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 order by 1,2,3,4
		</cfquery>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td nowrap class="TituloListas" align="center" style="text-transform:uppercase "><cfoutput>#LB_SubTit#</cfoutput></td>
		  </tr>
		</table>
		<cfinvoke component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pLista"
			formname="listacxp"
			query="#rslistacxc#"

			desplegar="Ddocumento,EDsaldo,Dmonto"
			etiquetas="#LB_Documento#,#LB_Saldo#,#LB_Monto#"
			formatos="S,M,M"
			align="left,right,right"

			cortes="SNnombre,CPTdescripcion"
			totales="EDsaldo,Dmonto"
			totalgenerales="EDsaldo,Dmonto"
			irA=""
			showEmptyListMsg="true"
			EmptyListMsg="#LB_Noseha#"
			navegacion="#navegacion#"
			PageIndex="3"/>
	</td>
  </tr>
</table>