<cfset navegacion = "">
<cfif isdefined ('url.PCEMid') and not isdefined('form.PCEMid')>
	<cfset form.PCEMid = url.PCEMid>
	<cfset navegacion = navegacion & "&PCEMid=#form.PCEMid#">
</cfif>

<cfif isdefined ('url.Ctipo') and not isdefined('form.Ctipo')>
	<cfset form.Ctipo = url.Ctipo>
</cfif>

<cfif isdefined ('url.LvarTipo') and not isdefined('form.LvarTipo')>
	<cfset form.LvarTipo = url.LvarTipo>
</cfif>

<cfif isdefined ('form.Cmayor1') and len(trim(form.Cmayor1))>
	<cfset LvarCuenta = 'Cuenta Ingresos N°: (#form.Cmayor1# - #form.Cdescripcion1#)'>
	<cfset LvarTipo = 'I'>

<cfelseif isdefined ('form.Cmayor2') and len(trim(form.Cmayor2))>
	<cfset LvarCuenta = 'Cuenta Egresos N°: (#form.Cmayor2# - #form.Cdescripcion2#)'>
	<cfset LvarTipo = 'E'>
	
<cfelseif isdefined ('form.Cmayor3') and len(trim(form.Cmayor3))>
	<cfset LvarCuenta = 'Cuenta Ingresos Transferencia N°: (#form.Cmayor3# - #form.Cdescripcion3#)'>
	<cfset LvarTipo = 'IT'>
	
<cfelseif isdefined ('form.Cmayor4') and len(trim(form.Cmayor4))>
	<cfset LvarCuenta = 'Cuenta Egresos Transferencia N°: (#form.Cmayor4# - #form.Cdescripcion4#)'>
	<cfset LvarTipo = 'ET'>

<cfelseif isdefined ('form.LvarTipo') and #form.LvarTipo# eq 'I'>
	<cfset LvarCuenta = 'Cuenta Ingresos N°: (#Cmayor# - #Cdescripcion#)'>
	
<cfelseif isdefined ('form.LvarTipo') and #form.LvarTipo# eq 'E'>
	<cfset LvarCuenta = 'Cuenta Egresos N°: (#Cmayor# - #Cdescripcion#)'>
	
<cfelseif isdefined ('form.LvarTipo') and #form.LvarTipo# eq 'IT'>
	<cfset LvarCuenta = 'Cuenta Ingresos Transferencia N°: (#Cmayor# - #Cdescripcion#)'>

<cfelseif isdefined ('form.LvarTipo') and #form.LvarTipo# eq 'ET'>
	<cfset LvarCuenta = 'Cuenta Egresos Transferencia N°: (#Cmayor# - #Cdescripcion#)'>
</cfif>

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
			<cf_dbfunction name="to_char" args="conf.PCEMid" returnvariable="PCEMid">
			<cf_dbfunction name="to_char" args="conf.PCNid" returnvariable="PCNid"> 
			<cf_dbfunction name="to_char" args="conf.PCTipo" returnvariable="PCTipo"> 
			<cf_dbfunction name="to_char" args="count(1)" returnvariable="Contador"> 
			<cf_dbfunction name="to_integer" args="conf.PCNid" returnvariable="PCNid2"> 
			<cf_dbfunction name="to_char" args="conf.PCFActivo" returnvariable="PCFActivo"> 
			<cf_dbfunction name="OP_concat" returnvariable="_Cat">

			<form name="lista1" action="ConfiguracionNivelCuenta_SQL.cfm?Ctipo=<cfoutput>#form.Ctipo#</cfoutput>" method="post">
				<input type="hidden" name="listados" id="listados" value="" />
				<input type="hidden" name="LvarTipo" id="LvarTipo" value="<cfoutput>#LvarTipo#</cfoutput>" />

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
							and conf.PCFActivo = 1
							and conf.PCTipo = '#LvarTipo#'"/>
				<cfinvokeargument name="columnas" value="
				a.PCEMid, 
				conf.PCLinea,
				conf.PCTipo,
				a.PCNid, 
				a.PCEcatid, 
				a.PCNlongitud, a.PCNdep, 
				conf.PCFActivo,
				#PCEMid# #_Cat# '|' #_Cat# 
				#PCNid#  #_Cat# '|' #_Cat# 
				(select rtrim(#Contador#)
				from PCNivelMascara d
						inner join PCEMascaras e
							on d.PCEMid = e.PCEMid
				where d.PCEMid = a.PCEMid and d.PCNid <= a.PCNid and d.PCNpresupuesto = 1
				) as idGroup,
				
				a.PCNdescripcion as desc1,
				a.PCNdep as nivel
				,case when a.PCNcontabilidad = 1 then 'SI'
				else null
				end as Conta
				,case when a.PCNpresupuesto = 1 then 'SI'	
				else null
				end as Presup, 
				(select rtrim(#Contador#)
				from PCNivelMascara d
						inner join PCEMascaras e
							on d.PCEMid = e.PCEMid
				where d.PCEMid = a.PCEMid and d.PCNid <= a.PCNid and d.PCNpresupuesto = 1
				) Linea
				"/>
				<cfinvokeargument name="desplegar" value="Linea, desc1, PCNlongitud, Conta, Presup"/>
				<cfinvokeargument name="etiquetas" value="Linea, Descripcion, Longitud, Conta, Presup"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,S,S"/>
				<cfinvokeargument name="filtro" value="a.PCEMid = #form.PCEMid# and a.PCNpresupuesto = 1 order by a.PCNid"/>
				<cfinvokeargument name="align" value="left, left, left, left, center, center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="formName" value="lista1"/>
				<cfinvokeargument name="keys" value="PCEMid,PCNid,Linea"/>
				<cfinvokeargument name="PageIndex" value="1"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Aceptar,Regresar"/>
				<cfinvokeargument name="checkedcol" value="idGroup"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
			</cfinvoke>
			</form>
		</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.href=history.back();
		return false;
	}
	
	function funcAceptar(){
		inicio = '';
		final = '';
		if(document.lista1.chk){
			if(document.lista1.chk.value){
				if (!document.lista1.chk.disabled){
					inicio = final = document.lista1.chk.value;
				}
			}else{
				inicio = final = document.lista1.chk[0].value;
				for(var i = 0; i < document.lista1.chk.length; i++){
					if (!document.lista1.chk[i].disabled)
						final = document.lista1.chk[i].value;
				}
			}
		}
		document.lista1.listados.value = inicio+","+final;
		
		return true;
	}
</script>


