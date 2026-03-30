<!--- Pasa Parámetros a Navegación --->

<!---------
	Modificado por: Ana Villavicencio
	Fecha: 18 de julio del 2005
	Motivo:	se modifico la llamada del componente de listas agregando un nuevo parametro 
			para mostrar el total general.
	Línea: 61
	
	Modificado por: Ana Villavicencio
	Fecha: 27 de julio del 2005
	Motivo:	Se eliminó el form q se estaba utilizando para la lista porque este provocaba un error en la lista.
			Se eliminó un hidden de IdDocumentoNeteo ya q hacia q se creara una lista con el ID del documento.
	Línea: 61
	
----------->

<cfset LB_SubTit = t.Translate('LB_SubTit','Lista de Documentos a Netear CXC')>   
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Neteo1.xml')>   
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','Neteo1.xml')>   
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Noseha = t.Translate('LB_Noseha',' -- No se ha agregado ningun documento -- ')>
<cfset LB_AntEfe = t.Translate('LB_AntEfe','(ANTICIPO EFECTIVO)')>   
<cfset LB_FavorSFE= t.Translate('LB_FavorSFE','(a favor Cliente sin flujo de efectivo)')>   

<cfset navegacion = "">
<cfif isdefined("form.idDocumentoNeteo")>
	<cfset navegacion = navegacion & "&idDocumentoNeteo=#form.idDocumentoNeteo#">
</cfif>
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset navegacion = navegacion & "&Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocumentoNeteo_F") and LEN(TRIM(form.DocumentoNeteo_F))>
	<cfset navegacion = navegacion & "&DocumentoNeteo_F=#form.DocumentoNeteo_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset navegacion = navegacion & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>
<cf_dbfunction name="op_concat" returnvariable="_CAT">
<cfquery name="rslistacxc" datasource="#session.dsn#">
	select 
		case when
			d.CCTtipo = 'C'
			and (
					select count(1)
					  from DDocumentos det
					 where det.Ddocumento	= c.Ddocumento
					   and det.CCTcodigo	= c.CCTcodigo
					   and det.Ecodigo		= c.Ecodigo
				) = 0 then 1
			when d.CCTtipo = 'C' then 2
			else 3
		end as ANTs,
		e.SNnombre, d.CCTcodigo, 
		c.Ddocumento, 
		d.CCTcodigo #_CAT# ': ' #_CAT# d.CCTdescripcion #_CAT#
		case 
			when d.CCTtipo = 'C'
			and (
					select count(1)
					  from DDocumentos det
					 where det.Ddocumento	= c.Ddocumento
					   and det.CCTcodigo	= c.CCTcodigo
					   and det.Ecodigo		= c.Ecodigo
				) = 0 then ' #LB_AntEfe#'
			when d.CCTtipo = 'C' then ' #LB_FavorSFE#'
			else ' (a cobrar)'
		end as CCTdescripcion,
		
		a.idDocumentoNeteo, b.idDetalle, 
		case CCTtipo when 'D' then c.Dsaldo else c.Dsaldo * -1 end as Dsaldo, 
		case CCTtipo when 'D' then b.Dmonto else b.Dmonto * -1 end as Dmonto, 
		d.CCTtipo,
		r.Rcodigo as RcodigoCxC, r.Rporcentaje
	from DocumentoNeteo a
		inner join DocumentoNeteoDCxC b
			inner join Documentos c
				inner join CCTransacciones d
				on d.CCTcodigo = c.CCTcodigo
				and d.Ecodigo =c.Ecodigo
			left join Retenciones r
				on r.Ecodigo = c.Ecodigo
				and r.Rcodigo = c.Rcodigo
			inner join SNegocios e 
				on e.SNcodigo = c.SNcodigo
				and e.Ecodigo = c.Ecodigo
			on c.Ddocumento = b.Ddocumento
			and c.CCTcodigo = b.CCTcodigo
			and c.Ecodigo = b.Ecodigo
		on b.idDocumentoNeteo = a.idDocumentoNeteo
		and b.Ecodigo = a.Ecodigo
	where a.idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocumentoNeteo#">
	 and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 1,2,3,4
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" nowrap class="TituloListas" align="center" style="text-transform:uppercase "><cfoutput>#LB_SubTit#</cfoutput></td>
		  </tr>
		</table>
		<cfinvoke component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pLista"
			formname="form1"
			query="#rslistacxc#"
			cortes="SNnombre,CCTdescripcion"
			totales="Dsaldo,Dmonto"
			totalgenerales="Dsaldo,Dmonto"

			desplegar="Ddocumento,Dsaldo,Dmonto"
			etiquetas="#LB_Documento#,#LB_Saldo#,#LB_Monto#"
			formatos="S,M,M"
			align="left,right,right"

			irA=""
			showEmptyListMsg="true"
			EmptyListMsg="#LB_Noseha#"
			navegacion="#navegacion#"
			PageIndex="2"
		/>
	</td>
  </tr>
</table>

		