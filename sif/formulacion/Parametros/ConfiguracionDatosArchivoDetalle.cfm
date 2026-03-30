<cfif isdefined ('url.PCEMid') and not isdefined('form.PCEMid')>
	<cfset form.PCEMid = url.PCEMid>
</cfif>

<cfif isdefined ('url.Ctipo') and not isdefined('form.Ctipo')>
	<cfset form.Ctipo = url.Ctipo>
</cfif>

<cfif (isdefined ('form.Cmayor1') and len(trim(form.Cmayor1)))>
	<cfset LvarCuenta = 'Cuenta N°: (#form.Cmayor1# - #form.Cdescripcion1#)'>
<cfelseif (isdefined ('form.Cmayor2') and len(trim(form.Cmayor2)))>
	<cfset LvarCuenta = 'Cuenta N°: (#form.Cmayor2# - #form.Cdescripcion2#)'>
<cfelse>
	<cfset LvarCuenta = 'Cuenta N°: (#Cmayor# - #Cdescripcion#)'>
</cfif>

<cfquery name="rsObtenerDetalles" datasource="#session.dsn#">
	select 
		count(1)
	from FPConfNivelCuenta 
	where PCEMid = #form.PCEMid# 
</cfquery>

<table border="0" align="center" width="100%">
	<tr>
		<td>
			<strong><cfoutput>#LvarCuenta#</cfoutput></strong>&nbsp;
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<cf_dbfunction name="OP_concat" returnvariable="_Cat">
			<cf_dbfunction name="to_char" args="conf.PCEMid" returnvariable="PCEMid">
			<cf_dbfunction name="to_char" args="conf.PCNid" returnvariable="PCNid"> 
			<cf_dbfunction name="to_char" args="conf.PCFActivo" returnvariable="PCFActivo"> 
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
					PCNivelMascara a
						inner join PCEMascaras b
							on a.PCEMid = b.PCEMid  
						left outer join PCECatalogo c
							on a.PCEcatid = c.PCEcatid 
						left outer join FPConfNivelCuenta conf
							on conf.PCEMid = a.PCEMid
							and conf.PCNid = a.PCNid
							and conf.Ecodigo = #session.Ecodigo#
							and conf.PCFActivo = 1"/>
				<cfinvokeargument name="columnas" value="
				a.PCEMid, 
				a.PCNid, 
				a.PCEcatid, 
				a.PCNlongitud, a.PCNdep, 
				conf.PCFActivo,
				
				#PCEMid# #_Cat# '|' #_Cat# #PCNid#  as idGroup,
				
				a.PCNdescripcion as desc1,
				a.PCNdep as nivel
				,case when a.PCNcontabilidad = 1 then 'SI'
				else null
				end as Conta
				,case when a.PCNpresupuesto = 1 then 'SI'
				else null
				end as Presup
				"/>
				<cfinvokeargument name="desplegar" value="PCNid, desc1, PCNlongitud, Conta, Presup"/>
				<cfinvokeargument name="etiquetas" value="Nivel, Descripcion, Longitud, Conta, Presup"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,S,S"/>
				<cfinvokeargument name="filtro" value="a.PCEMid = #form.PCEMid# order by a.PCNid"/>
				<cfinvokeargument name="align" value="left, left, left, center, center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="formName" value="lista1"/>
				<cfinvokeargument name="keys" value="PCEMid,PCNid"/>
				<cfinvokeargument name="irA" value="ConfiguracionNivelCuenta_SQL.cfm?Ctipo=#form.Ctipo#"/>
				<cfinvokeargument name="PageIndex" value="321"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Aceptar,Regresar"/>
				<cfinvokeargument name="checkedcol" value="idGroup"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
	function funcRegresar()
	 {
		document.href=history.back();
		return false;
	 }
</script>


