<!---
PROBLEMA: 
	Algunos documentos, cuyo tipo es debito (FC por ejemplo), tienen montos negativos.
	Se supone que esto no debe suceder, solo los de tipo Credito pueden tener montos negativos.
	REVISAR DONDE HACE ESTO!


 <cfquery name="rsDatosFact" datasource="#session.DSN#">
 	select count(Ddocumento) as CantDoc, EDAtotalglobal, Miso4217 
	from EDocumentosAgrupados ed inner join Monedas m
	  on ed.Ecodigo = m.Ecodigo and 
   		 ed.Mcodigo = m.Mcodigo
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
 </cfquery><cf_dump var="#form#">
 
	Modificado por: Ana Villavicencio
	Fecha: 16 de setiembre del 2005
	Motivo: se cambio el procesamiento de la lectura de la lista q contiene los documentos a aplicar.  
			La variable que se utilizaba anteriormente era form.chk ahora se utiliza listaDocs, q se crea en 
			la pantalla de confirmación con los datos de los documentos seleccionados.
			Se agregaron parametros para tomar en cuenta periodo, mes, firmaAutorizada e idioma.

	Modificado por: Ana Villavicencio 
	Fecha: 20 de setiembre del 2005
	Motivo:	Se cambio las consultas  y actualizaciones sobre la tabla Documentos 
			y ahora se hace sobre la tabla HDocumentos (historico).
			Se cambio la seleccion del identificador del Documento Agrupado (Dreferencia), 
			se toma en cuenta el maximo del tipo de movimiento (D o C).
			Corregir error en la actualización del total global del documento impreso.  Se agregó a la consulta el tomar
			en cuenta el tipo de documento y movimiento, esto porque el numero de referencia para una factura puede ser el
			mismo para una nota de credito, de manera q se tiene q diferenciar cuando hace la consulta y las actualizaciones.

--->

<cfset params = '' >
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset  params = params & "&SNcodigo=#form.SNcodigo#">
</cfif>
<cfif isdefined("form.CCtipo") and len(trim(form.CCtipo))>
	<cfset  params = params & "&CCtipo=#form.CCtipo#">
</cfif>
<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
	<cfset  params = params & "&Mcodigo=#form.Mcodigo#">
</cfif>
<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
	<cfset  params = params & "&Periodo=#form.Periodo#">
</cfif>
<cfif isdefined("form.Mes") and len(trim(form.Mes))>
	<cfset  params = params & "&Mes=#form.Mes#">
</cfif>
<cfif isdefined("idioma") and len(trim(idioma))>
	<cfset  params = params & "&Idioma=#idioma#">
</cfif>
<cfif isdefined("firmaAutorizada") and len(trim(firmaAutorizada))>
	<cfset  params = params & "&firmaAutorizada=#firmaAutorizada#">
</cfif>
<cfif not isdefined('Form.Aceptar') and not isdefined('form.filtrar')>
	<cfinclude template="confirmarImpresion.cfm"> 
<cfelseif isdefined('form.Aceptar')> 
<cfif isdefined("form.listaDocs") and len(trim(form.listaDocs))>
	<!--- calcula numero de referencia --->

	<cfquery name="rsReferencia" datasource="#session.DSN#">
		select max(Dreferencia) as referencia
		 from EDocumentosAgrupados a
		inner join CCTransacciones b
		   on a.Ecodigo   = b.Ecodigo and
		      a.CCTcodigo = b.CCTcodigo
		where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.CCTtipo   = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCtipo#">
	</cfquery>
	<cfset referencia = 1 >
	<cfif rsReferencia.RecordCount gt 0 and len(trim(rsReferencia.referencia))>
		<cfset referencia = rsReferencia.referencia + 1 >
	</cfif>
	<!--- Procesamiento de los registros  seleccionados --->
	<cftransaction>
	<cfloop list="#listaDocs#" index="dato" delimiters=",">
		<!--- Inserta encabezados de documentos --->
		<cfquery datasource="#session.DSN#" name="selectInserta">
			select 	 
					SNcodigo, 
					CCTcodigo, 
					Ddocumento,	 
					coalesce(Icodigo, ' ') as Icodigo, 
					Mcodigo, 
					Ocodigo, 
					Dtipocambio as TC, 
					abs(Dtotal) as EDAtotaldoc,
					0.00 as EDAtotalglobal, <!----- total de todos los documentos por agrupar--->
					'P' as EDAestado, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaFact)#"> as EDAfechaglobal, <!----- fecha del documento "agrupador"--->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaFact)#">  as EDAfechavenc <!----- preguntar a mesquivel--->
			from HDocumentos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(dato,1,'|')#">
  			  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(dato,2,'|')#">
		</cfquery>
		<cfquery datasource="#session.DSN#" name="inserta">
			insert  into EDocumentosAgrupados( Ecodigo, BMUsucodigo, SNcodigo, CCTcodigo, Ddocumento, Dreferencia, Icodigo, Mcodigo, 
										 Ocodigo, fechaalta, TC, EDAtotaldoc, EDAtotalglobal, EDAestado, EDAfechaglobal, EDAfechavenc )
						VALUES(
							   #session.Ecodigo#,
							   #session.Usucodigo#,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInserta.SNcodigo#"       voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectInserta.CCTcodigo#"      voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectInserta.Ddocumento#"     voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#referencia#"    				voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectInserta.Icodigo#"        >,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectInserta.Mcodigo#"        voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectInserta.Ocodigo#"        voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectInserta.TC#"             voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectInserta.EDAtotaldoc#"    voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectInserta.EDAtotalglobal#" voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectInserta.EDAestado#"      voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectInserta.EDAfechaglobal#" voidNull>,
							   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectInserta.EDAfechavenc#"   voidNull>
							   
						)				 
									
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
		<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
		
		<cfset id = inserta.identity >

		<!--- Inserta detalle de documentos --->
		<cfquery datasource="#session.DSN#">
			insert into DDocumentosAgrupados( EDAid, DDlinea, Ecodigo, Alm_Aid, Dcodigo, DDtotal, DDcodartcon, DDtipo, DDcantidad, 
										 DDpreciou, DDdesclinea, DDcostolin, DDescripcion, DDdescalterna, BMUsucodigo, fechaalta )
										 
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">, 
					DDlinea, 
					Ecodigo, 
					Alm_Aid, 
					Dcodigo, 
					abs(DDtotal), 
					coalesce(DDcodartcon, 0), 
					DDtipo, 
					DDcantidad, 
				   	DDpreciou, 
					abs(coalesce(DDdesclinea, 0.00)), 
					abs(coalesce(DDcostolin, 0.00)), 
					DDescripcion, 
					DDdescalterna, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			
			from HDDocumentos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(dato,1,'|')#">
  			  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(dato,2,'|')#">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			update HDocumentos
			set Dreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#referencia#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(dato,1,'|')#">
			  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(dato,2,'|')#">
		</cfquery>
 	</cfloop>
	
	<!--- calcula el total global para los documentos agrupados --->
	<cfquery name="rsTotalGlobal" datasource="#session.DSN#" >
		select sum(EDAtotaldoc) as EDAtotalgloblal, a.CCTcodigo
		from EDocumentosAgrupados a
		inner join CCTransacciones b
		   on a.Ecodigo   = b.Ecodigo and
		      a.CCTcodigo = b.CCTcodigo
		where Dreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#referencia#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.CCTtipo   = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCtipo#">
		group by a.CCTcodigo
	</cfquery>
	<cfif len(trim(rsTotalGlobal.EDAtotalgloblal))>
		<cfquery datasource="#session.DSN#">
			update EDocumentosAgrupados 
			set EDAtotalglobal = <cfqueryparam cfsqltype="cf_sql_money4" value="#rsTotalGlobal.EDAtotalgloblal#">
			where Dreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#referencia#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTotalGlobal.CCTcodigo#">
		</cfquery>
	</cfif>
	</cftransaction>
	<cfif isdefined("referencia") and len(trim(referencia))>
	<cfset  params = params & "&Dreferencia=#referencia#">
	</cfif>
</cfif>

<cfoutput>

<cflocation url="impresionFacturas.cfm?imprimir=true#params#">

</cfoutput>
<cfelse>
 	<cflocation url="impresionFacturas.cfm?1=1#params#">
 </cfif>

<form name="form1" method="post" action="impresionFacturas.cfm"></form><!--- --->