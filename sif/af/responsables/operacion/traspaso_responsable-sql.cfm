<!---Funcionalidad Especial El Usuario Funciona como Id del Documento por Falta de ID de Documento --->
<cfif isdefined("form.btnAgregarMasivo")>
		<cfif len(trim(form.DEid)) gt 0 and form.DEid gt 0>
			<cfset form.DEid = #LSParseNumber(form.DEid)#>						
		</cfif>
		<cfif len(trim(form.Aplacai)) gt 0 and form.Aplacai gt 0>
			<cfset form.Aplacai =#form.Aplacai#>
		</cfif>
		<cfif len(trim(form.Aplacai)) gt 0 and form.Aplacai gt 0>
			<cfset form.Aplacaf = #form.Aplacai#> <!--- Como se quitÃ³ el filtro, entonces la placa final = inicial --->
		</cfif>
		<cfif len(trim(form.CRTDid)) gt 0 and form.CRTDid gt 0>
			<cfset form.CRTDid =#form.CRTDid#>
		</cfif>
		<cfif len(trim(form.CFid)) gt 0 and form.CFid gt 0>
			<cfset form.CFid = #form.CFid#>
		</cfif>
		<!--- 0.2	ParÃ¡metros de Datos de la Tranferencia --->
		<cfif len(trim(form.CRTDid2)) gt 0 and form.CRTDid2 gt 0>
			<cfset CRTDid2 = #form.CRTDid2#><!--- Permite modificar el tipo --->
		</cfif>

	<cf_dbfunction name="to_char" args="a.AFTRid" returnvariable="LvarAFTRid">
	<cfquery  name="rsDatos" datasource="#session.dsn#">
	select count(1) as cantidad, act.Aplaca, pr.ADTPlinea,a.DEid
		from AFResponsables a
			inner join ADTProceso pr
			on pr.Ecodigo = a.Ecodigo 
			and pr.Aid = a.Aid
			inner join Activos act
			on act.Aid = pr.Aid
		where a.Ecodigo = #session.Ecodigo#
			and a.CRCCid = #form.CRCCid#
			and <cf_dbfunction name="now"> between AFRfini and AFRffin
			and (select count(1)
				  from AFTResponsables x
				where x.AFRid = a.AFRid
				and x.Usucodigo = #session.Usucodigo#
				and x.AFTRtipo = 1
			) < 1
			
			<cfif form.DEid gt 0>
				and a.DEid = #form.DEid#
			</cfif>

			<cfif isdefined ('form.Aplacai') and len(#form.Aplacai#) gt 0 or isdefined ('form.Aplacaf') and len(#form.Aplacaf#) gt 0>
				and exists (
					select 1
					from Activos 
					where Activos.Aid = a.Aid
					and  Activos.Ecodigo = a.Ecodigo
					
					<cfif isdefined ('form.Aplacai') and len(#form.Aplacai#) gt 0>
						and Activos.Aplaca >= '#form.Aplacai#'
					</cfif>
					
					<cfif isdefined ('form.Aplacaf') and len(#form.Aplacaf#) gt 0>
						and Activos.Aplaca <= '#form.Aplacaf#'
					</cfif>
				)
			</cfif>		
			<cfif isdefined ('form.CFid') and form.CFid gt 0>
				and a.CFid = #form.CFid#
			</cfif>		
			
			<cfif isdefined ('form.CRTDid') and form.CRTDid gt 0>
				and a.CRTDid = #form.CRTDid#
			</cfif>	
			group by act.Aplaca, pr.ADTPlinea,a.DEid	
	</cfquery>
	
	<cfif #rsDatos.cantidad# gt 0>
		<script language="javascript" type="text/javascript">
			alert("Existen Activos que no se incluirán por estar asociados a transacciones pendientes de aplicar!.");
		var PARAM  = "/cfmx/sif/af/responsables/operacion/ActivosEnTransaccionesPendientes.cfm?<cfif isdefined ('rsDatos.Aplaca') and len(trim(rsDatos.Aplaca))>Aplaca=<cfoutput>#rsDatos.Aplaca#</cfoutput></cfif>&<cfif isdefined ('form.CRTDid') and len(trim(form.CRTDid))>CRTDid=<cfoutput>#form.CRTDid#</cfoutput></cfif>&<cfif isdefined ('form.DEid') and len(trim(form.DEid))>DEid=<cfoutput>#form.DEid#</cfoutput></cfif>&<cfif isdefined ('form.CFid') and len(trim(form.CFid))>CFid=<cfoutput>#form.CFid#</cfoutput>"</cfif>;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=900,height=500')
	</script>
	</cfif>

	<cfinvoke 
		component="sif.Componentes.AF_CambioResponsable" 
		method="TransferirMasivo" 
		returnvariable="ret">
		<!--- 0.1	ParÃ¡metros de BÃºsqueda de Responsables --->
		<cfinvokeargument name="CRCCid" value="#form.CRCCid#"/>
		<cfif len(trim(form.DEid)) gt 0 and form.DEid gt 0>
			<cfinvokeargument name="DEid" value="#LSParseNumber(form.DEid)#"/>						
		</cfif>
		<cfif len(trim(form.Aplacai)) gt 0 and form.Aplacai gt 0>
			<cfinvokeargument name="Aplacai" value="#form.Aplacai#"/>
		</cfif>
		<cfif len(trim(form.Aplacai)) gt 0 and form.Aplacai gt 0>
			<cfinvokeargument name="Aplacaf" value="#form.Aplacai#"/> <!--- Como se quitÃ³ el filtro, entonces la placa final = inicial --->
		</cfif>
		<cfif len(trim(form.CRTDid)) gt 0 and form.CRTDid gt 0>
			<cfinvokeargument name="CRTDid" value="#form.CRTDid#"/>
		</cfif>
		<cfif len(trim(form.CFid)) gt 0 and form.CFid gt 0>
			<cfinvokeargument name="CFid" value="#form.CFid#"/>
		</cfif>
		<!--- 0.2	ParÃ¡metros de Datos de la Tranferencia --->
		<cfif len(trim(form.CRTDid2)) gt 0 and form.CRTDid2 gt 0>
			<cfinvokeargument name="CRTDid2" value="#form.CRTDid2#"/><!--- Permite modificar el tipo --->
		</cfif>
		<cfinvokeargument name="CRCCid2" value="#form.CRCCid#"/>
		<cfinvokeargument name="DEid2" value="#LSParseNumber(form.DEid2)#"/>		
		<cfinvokeargument name="Fecha" value="#form.Fecha#"/>
		<cfinvokeargument name="Estado" value="30"/>
		<cfinvokeargument name="Tipo" value="1"/>
		<cfinvokeargument name="Debug" value="0"/>
	</cfinvoke>
<!---Importador de Traslados de Responsables--->
<cfelseif isdefined("form.btnImportar")>
	<cflocation url="../../importar/ImportarTrasladosR.cfm">
<cfelseif isdefined("form.btnEliminarMasivo")>
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cfif isdefined('form.Boleta') and #form.Boleta# eq 1>
		<cfquery name="VerificaDato" datasource="#session.dsn#">
			select count(1) as cantidad, rtrim(LTRIM(act.Aplaca)) as Aplaca
			from TransConsecutivo a 
			inner join AFTResponsables b 
				 on b.AFTRid = a.AFTRid
			inner join AFResponsables afr
				on afr.AFRid = b.AFRid
			left outer join Activos act
				on act.Aid = afr.Aid
			 where a.AFTRid in (#form.chk#)
			 group by act.Aplaca	
		</cfquery>
		
		<cfif VerificaDato.cantidad neq ''>
			<cfset LvarAct = ''>
		<cfloop query="VerificaDato">
		 <cfif len(trim(LvarAct))>
			<cfset LvarAct =LvarAct &', '& #VerificaDato.Aplaca#>
		<cfelse>
			<cfset LvarAct =#VerificaDato.Aplaca#>
		</cfif>
		</cfloop>
			<script language="javascript" type="text/javascript">
				alert("No se puede eliminar el Registro porque la(s) placa(s) <cfoutput>#LvarAct#</cfoutput>posee(n) Consecutivo!.");
			</script>
		<cfelse>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AnularMasivo">
			<cfinvokeargument name="AFTRidlist" value="#form.chk#"/>
		</cfinvoke>
		</cfif>
	<cfelse>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AnularMasivo">
			<cfinvokeargument name="AFTRidlist" value="#form.chk#"/>
		</cfinvoke>
	</cfif>

<cfelseif isdefined("form.btnEliminarByUsucodigo")>
	 <cfinvoke 
		component="sif.Componentes.AF_CambioResponsable"
		method="AnularByUsucodigo"/>
		
<cfelseif isdefined("form.btnAplicarMasivo")>
<cfif isdefined('form.Boleta') and #form.Boleta# eq 1>
	<cfquery name="VerificaDato" datasource="#session.dsn#">
		select count(1) as cantidad, rtrim(LTRIM(act.Aplaca)) as Aplaca
		from AFTResponsables b 
		inner join AFResponsables afr
			on afr.AFRid = b.AFRid
		left outer join Activos act
			on act.Aid = afr.Aid
		where b.AFTRid in (#form.chk#)
			  and (select count(1)
					from TransConsecutivo a 
					inner join AFTResponsables x 
						 on x.AFTRid = a.AFTRid
					inner join AFResponsables afr
						on afr.AFRid = x.AFRid
					left outer join Activos act
						on act.Aid = afr.Aid
					where a.AFTRid = b.AFTRid
						) < 1
		 group by act.Aplaca	
	</cfquery>

	<cfif VerificaDato.cantidad neq ''>
		<cfset LvarAct = ''>
	<cfloop query="VerificaDato">
	 <cfif len(trim(LvarAct))>
		<cfset LvarAct =LvarAct &', '& #VerificaDato.Aplaca#>
	<cfelse>
		<cfset LvarAct =#VerificaDato.Aplaca#>
	</cfif>
	</cfloop>
		<script language="javascript" type="text/javascript">
			alert("No se puede Aplicar porque la(s) placa(s) <cfoutput>#LvarAct#</cfoutput> No tiene(n) Consecutivo!.");
		</script>
	<cfelse>
	<cfinvoke 
		component="sif.Componentes.AF_CambioResponsable"
		method="ProcesarMasivo">
		<cfinvokeargument name="AFTRidlist" value="#form.chk#"/>
	</cfinvoke>
	</cfif>
<cfelse>
	<cfinvoke 
		component="sif.Componentes.AF_CambioResponsable"
		method="ProcesarMasivo">
		<cfinvokeargument name="AFTRidlist" value="#form.chk#"/>
	</cfinvoke>
</cfif>
<cfelseif isdefined("form.btnAplicarByUsucodigo")>
<cfif isdefined('form.Boleta') and #form.Boleta# eq 1>
	<cfquery name="VerificaDato" datasource="#session.dsn#">
		select count(1) as cantidad, rtrim(LTRIM(act.Aplaca)) as Aplaca
		from AFTResponsables b 
		inner join AFResponsables afr
			on afr.AFRid = b.AFRid
		left outer join Activos act
			on act.Aid = afr.Aid
			where b.AFTRid in (#form.chk#) 
            	and (select count(1)
					from TransConsecutivo a 
					inner join AFTResponsables x 
						 on x.AFTRid = a.AFTRid
					inner join AFResponsables afr
						on afr.AFRid = x.AFRid
					left outer join Activos act
						on act.Aid = afr.Aid
					where a.AFTRid = b.AFTRid
						) < 1
		 group by act.Aplaca	
	</cfquery>

	<cfif VerificaDato.cantidad neq ''>
		<cfset LvarAct = ''>
	<cfloop query="VerificaDato">
	 <cfif len(trim(LvarAct))>
		<cfset LvarAct =LvarAct &', '& #VerificaDato.Aplaca#>
	<cfelse>
		<cfset LvarAct =#VerificaDato.Aplaca#>
	</cfif>
	</cfloop>
		<script language="javascript" type="text/javascript">
			alert("No se puede Aplicar porque la(s) placa(s) <cfoutput>#LvarAct#</cfoutput> No tiene(n) Consecutivo!.");
		</script>
	<cfelse>
	<cfinvoke 
		component="sif.Componentes.AF_CambioResponsable"
		method="ProcesarByUsucodigo"/>
	</cfif>
<cfelse>
	<cfinvoke 
		component="sif.Componentes.AF_CambioResponsable"
		method="ProcesarByUsucodigo"/>
	</cfif>
<cfelseif	isdefined("url.AnularError")>
	<cfif 	isdefined("url.AFTRid") and len(trim(url.AFTRid)) gt 0 and url.AFTRid gt 0>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AnularConse">
			<cfinvokeargument name="AFTRid" value="#url.AFTRid#"/>
			<cfinvokeargument name="AFTRazon" value="#url.CPDEmsgrechazo#"/>
			<cfinvokeargument name="AFTRechazado" value="1"/>
		</cfinvoke>
	</cfif>	
<cfelseif	isdefined("url.EliminarError")>
	<cfif 	isdefined("url.AFTRid") and len(trim(url.AFTRid)) gt 0 and url.AFTRid gt 0>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="Anular">
			<cfinvokeargument name="AFTRid" value="#url.AFTRid#"/>
		</cfinvoke>
	<cfelseif isdefined("url.ErrorNum") and len(trim(url.ErrorNum)) gt 0 and url.ErrorNum gt 0>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AnularByErrorNum">
			<cfinvokeargument name="ErrorNum" value="#url.ErrorNum#"/>
		</cfinvoke >
	</cfif>
</cfif>
<form action="traspaso_resposable.cfm" method="post" name="sql">	
	<cfoutput>	
		<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))> 
			<input name="CRCCid" value="#form.CRCCid#" type="hidden">
		</cfif>				
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<input name="DEid" value="#form.DEid#" type="hidden">
		</cfif>	
		<cfif isdefined("form.Aplacai") and len(trim(form.Aplacai))>
			<input name="Aplacai" value="#form.Aplacai#" type="hidden">
		</cfif>
		<cfif isdefined("form.CFid") and len(trim(form.CFid))>		
			<input name="CFid" value="#form.CFid#" type="hidden">
		</cfif>
		<cfif isdefined("CRTDid") and len(trim(form.CRTDid))>		
			<input name="CRTDid" value="#form.CRTDid#" type="hidden">
		</cfif>
		<cfif isdefined("form.btnAgregarMasivo")>
			<input name="Agregar" value="Agregar" type="hidden">
		</cfif>
	</cfoutput>									
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
