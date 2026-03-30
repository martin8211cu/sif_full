<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 25 de febrero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
 --->

<cfif isdefined("Form.Bloque")>
	<cfset Form.Hbloque = Form.Bloque>
</cfif>

<cfif isdefined("Url.Hcodigo") and not isdefined("Form.Hcodigo")>
	<cfset Form.Hcodigo = Url.Hcodigo>
</cfif>
<cfif isdefined("Url.Hbloque") and not isdefined("Form.Hbloque")>
	<cfset Form.Hbloque = Url.Hbloque>
</cfif>

<cfset modo = "ALTA">
<cfset modoDet = "ALTA">

<cfif isdefined("Form.Hcodigo") and LEN(TRIM(form.Hcodigo)) and form.Hcodigo GT 0>
	<cfset modo="CAMBIO">
	<cfif isdefined('form.Hbloque') and LEN(TRIM(form.Hbloque)) and form.Hbloque GT 0>
		<cfset modoDet = "CAMBIO">
	</cfif>
</cfif>

<cfparam name="form.Filtro_Hnombre" default="">
<cfparam name="form.HFiltro_Hnombre" default="">
<cfparam name="form.MaxRows" default="10">
<!--- Consultas --->

<!--- 1. Form Encabezado --->
<!--- Seccion del detalle --->
<cfif modoDet NEQ 'ALTA'>
	<cfif isdefined("Form.Hcodigo") and Form.Hcodigo NEQ "" and isdefined("Form.Hbloque") and Form.Hbloque NEQ "" >
		<!--- 1. Form --->	
		<cfquery datasource="#Session.Edu.DSN#" name="rsHorarioDetalle">
			select convert(varchar,b.Hcodigo) as Hcodigo, b.Hbloque,  b.Hbloquenombre, isnull(b.Hentrada,0) as Hentrada, isnull(b.Hsalida,0) as Hsalida,  b.Htipo  
			from HorarioTipo a, Horario b 
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
			  and a.Hcodigo = b.Hcodigo
			<cfif isdefined("Form.Hcodigo") AND Form.Hcodigo NEQ "" >
			  and b.Hcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hcodigo#">
			</cfif>
			<cfif isdefined("Form.Hbloque") AND Form.Hbloque NEQ "" >
			  and b.Hbloque =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hbloque#">
			</cfif>	
		</cfquery>
	</cfif>
</cfif>

<cfif modo NEQ 'ALTA' and isdefined("Form.Hcodigo") and Form.Hcodigo NEQ "">

	<cfquery datasource="#Session.Edu.DSN#" name="rsHorario">
		select Hnombre from HorarioTipo 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
		<cfif isdefined("Form.Hcodigo") AND #Form.Hcodigo# NEQ "" >
		  and Hcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Hcodigo#">
		</cfif>	
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayHorarioGuia">
		<!--- Existen dependencias con HorarioGuia--->
		select 1 
		from HorarioGuia a, HorarioTipo b
		where a.Hcodigo= <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
		  and a.Hcodigo = b.Hcodigo
		  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
	</cfquery>
	<cfif modoDet NEQ 'ALTA' and isdefined("Form.Hbloque") >
		<cfquery datasource="#Session.Edu.DSN#" name="rsHayHorarioGuiaDetalle">
			<!--- Existen dependencias con HorarioGuia--->
			select isnull(1,0) 
			from HorarioGuia a, HorarioTipo b
			where a.Hcodigo= <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
			  and a.Hbloque= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Hbloque#">
			  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
			  and a.Hcodigo = b.Hcodigo
		</cfquery>
	</cfif>
</cfif>	

<!---------------------------------------------------------------------------------- --->
<link href="../../css/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" type="text/JavaScript">

	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	  window.onfocus=closePopUp;
	}
		
	function doConlisAplicaGradoAhorario() {
		//alert(Hcodigo);
		popUpWindow("ConlisAplicaGradoAhorario.cfm?Hcodigo="+document.form1.Hcodigo.value,225,225,600,350);
	}
	
	function irALista() {
		location.href = "listaHorarioTipo.cfm";
	}

	function closePopUp() {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin = 0;
	  }
	}

</script>


<form name="form1" method="post" action="SQLHorarioTipo.cfm">
  <cfoutput>
  <input name="Hcodigo" type="hidden" id="Hcodigo" value="<cfif isdefined('form.Hcodigo')>#Form.Hcodigo#</cfif>" >
  <input type="hidden" name="MaxRows" value="<cfoutput>#form.MaxRows#</cfoutput>">
  <input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
  <input name="Pagina2" type="hidden" value="<cfif isdefined('form.Pagina2')>#form.Pagina2#</cfif>">
  <input name="Filtro_NombreBloque" type="hidden" value="<cfif isdefined('form.Filtro_NombreBloque')>#form.Filtro_NombreBloque#</cfif>">
  <input name="Filtro_Entrada" type="hidden" value="<cfif isdefined('form.Filtro_Entrada')>#form.Filtro_Entrada#</cfif>">
  <input name="Filtro_Salida" type="hidden" value="<cfif isdefined('form.Filtro_Salida')>#form.Filtro_Salida#</cfif>">
  <input name="Filtro_Tipo" type="hidden" value="<cfif isdefined('form.Filtro_Tipo')>#form.Filtro_Tipo#</cfif>">
  <input name="Filtro_Hnombre" type="hidden" value="<cfif isdefined('form.Filtro_Hnombre')>#form.Filtro_Hnombre#</cfif>">
  <input name="HFiltro_Hnombre" type="hidden" value="<cfif isdefined('form.HFiltro_Hnombre')>#form.HFiltro_Hnombre#</cfif>">
  <input name="FechaIni" type="hidden" value="<cfif isdefined('form.FechaIni')>#form.FechaIni#</cfif>">
  <input name="FechaFin" type="hidden" value="<cfif isdefined('form.FechaFin')>#form.FechaFin#</cfif>">
  </cfoutput>
  <table width="100%" border="0">
	 <tr> 
      	<td align="center" <cfif modo NEQ "ALTA">colspan="2"<cfelse>colspan="4"</cfif>class="tituloAlterno">
			<cfif modo EQ "ALTA">
				Nuevo <cfelse>Modificar 
			</cfif>
        	Horario
		</td>
    </tr>
	<cfoutput>
    <tr> 
		<td <cfif modo NEQ "ALTA">colspan="2" </cfif>valign="top">
			<table width="100%" cellpadding="2" cellspacing="2" border="0">
				<tr>
					<td width="30%" align="right" nowrap>Descripci&oacute;n</td>
				  	<td width="70%" nowrap>
				  		<input name="Hnombre" type="text" id="Hnombre" size="80" tabindex="1" maxlength="100" 
							onfocus="javascript:this.select();" 
							value="<cfif modo NEQ 'ALTA'><cfoutput>#rsHorario.Hnombre#</cfoutput></cfif>">
					</td>
					<cfif modo NEQ "ALTA" and isdefined("Form.Hcodigo")>
					  <input type="hidden" name="HayHorarioGuia" value="#rsHayHorarioGuia.recordCount#" >
					</cfif>
				</tr>
				<cfset Lvar_regresa = "listaHorarioTipo.cfm?Pagina=" & form.Pagina & "&Filtro_Hnombre=" & form.Filtro_Hnombre & "&HFiltro_Hnombre=" & form.HFiltro_Hnombre>
				<cfif isdefined('form.Hcodigo') and LEN(TRIM(form.Hcodigo))>
					<cfset Lvar_regresa = Lvar_regresa & "&Hcodigo=" & form.Hcodigo>
				</cfif>
				<cfif modo EQ "ALTA">
					<tr><td colspan="2"><cf_botones modo="#modo#" Regresar="#Lvar_regresa#"></td></tr>
				</cfif>
			</table>
			<cfif modoDet NEQ 'ALTA' and isdefined("Form.Hbloque")>
				  <input type="hidden" name="HayHorarioGuiaDetalle" 
				  value="<cfif isdefined('rsHayHorarioGuiaDetalle') and  #rsHayHorarioGuiaDetalle.RecordCount# GT 0>#rsHayHorarioGuiaDetalle.recordCount#<cfelse>0</cfif>">
			</cfif>
		</td>
	</tr>
	</cfoutput>
	<cfif modo NEQ "ALTA">
	<tr><td colspan="2"><hr></td></tr>
	<tr>
		<td valign="top" style="padding-left: 10px" colspan="2">
			<cfif modoDet NEQ "ALTA">
				<input type="hidden" name="Hbloque" id="Hbloque" value="<cfoutput>#Form.Hbloque#</cfoutput>">
			</cfif>
			<table border="0" width="100%" cellpadding="2" cellspacing="2">
				<tr>
					<td width="50%" align="right" nowrap>Nombre:&nbsp;</td>
					<td nowrap>
						<input name="Hbloquenombre" type="text" id="Hbloquenombre" tabindex="1" size="30" maxlength="80" 
							onfocus="javascript:this.select();" 
							value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsHorarioDetalle.Hbloquenombre#</cfoutput></cfif>">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>Tipo:&nbsp;</td>
					<td nowrap>
						<select name="Htipo" id="Htipo" tabindex="1">
						  <option value="1" <cfif modoDet NEQ 'ALTA' and #rsHorarioDetalle.Htipo# EQ 1>selected</cfif>>Clase</option>
						  <option value="2" <cfif modoDet NEQ 'ALTA' and #rsHorarioDetalle.Htipo# EQ 2>selected</cfif>>Recreo</option>
						  <option value="3" <cfif modoDet NEQ 'ALTA' and #rsHorarioDetalle.Htipo# EQ 3>selected</cfif>>Almuerzo</option>
						  <option value="4" <cfif modoDet NEQ 'ALTA' and #rsHorarioDetalle.Htipo# EQ 4>selected</cfif>>Actividad no curricular</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>Hora de Entrada:&nbsp;</td>
					<td nowrap>
					<cfoutput>
					  <select name="Hentrada" id="Hentrada" tabindex="1">
						<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0>
						  <cfset residuo = Fix(Val(rsHorarioDetalle.Hentrada))>
						</cfif>
						<cfloop index="i" from="0" to="23">
						  <option value="#i#"<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0 and #residuo# EQ i>selected</cfif>>#i# 
						  h</option>
						</cfloop>
					  </select>
					  <select name="HentradaMin" id="HentradaMin" tabindex="1">
						<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0>
						  <cfset residuo2 = 100 * (Val(rsHorarioDetalle.Hentrada) - Fix(Val(rsHorarioDetalle.Hentrada)))>
						</cfif>
						<cfloop index="i" from="0" to="55" step="5">
						  <option value="<cfif i LESS THAN 10>0</cfif>#i#"<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0 and Val(residuo2) EQ Val(i)>selected</cfif>>#i# 
						  min</option>
						</cfloop>
					  </select>
					</cfoutput>
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>Hora de Salida:&nbsp;</td>
					<td nowrap>
					<cfoutput>
					  <select name="Hsalida" id="Hsalida" tabindex="1">
						<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0>
						  <cfset residuo = Fix(Val(rsHorarioDetalle.Hsalida))>
						</cfif>
						<cfloop index="i" from="0" to="23">
						  <option value="#i#"<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0 and val(residuo) EQ val(i)>selected</cfif>>#i# 
						  h</option>
						</cfloop>
					  </select>
					  <select name="HsalidaMin" id="HsalidaMin" tabindex="1">
						<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0>
						  <cfset residuo2 = 100 * (Val(rsHorarioDetalle.Hsalida) - Fix(Val(rsHorarioDetalle.Hsalida)))>
						</cfif>
						<cfloop index="i" from="0" to="55" step="5">
						  <option value="<cfif i LESS THAN 10>0</cfif>#i#"<cfif modoDet NEQ 'ALTA' and rsHorarioDetalle.recordCount NEQ 0 and Val(residuo2) EQ Val(i)>selected</cfif>>#i# 
						  min</option>
						</cfloop>
					  </select>
					</cfoutput>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td <cfif modo NEQ "ALTA">colspan="2" </cfif>>
						<cfif modo NEQ "ALTA">
							<cfset Lvar_Aplicar = "Aplicar">
						<cfelse>
							<cfset Lvar_Aplicar = "">
						</cfif>
						<cf_botones modo="#modo#" modoDet="#modoDet#" nameEnc="Horario" Regresar="#Lvar_regresa#" include="#Lvar_Aplicar#">
					</td>
				</tr>
			</table>
		</td>
    </tr>
	</cfif>
  </table>
  </form>
  <cfif modo NEQ "ALTA">
		<cfset navegacion = "">
		
		<cfif isdefined("Form.Hcodigo") and Form.Hcodigo NEQ ''>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Hcodigo=" & Form.Hcodigo>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pagina2=" & Form.Pagina2>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pagina=" & Form.Pagina>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Hnombre=" & Form.Filtro_Hnombre>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HFiltro_Hnombre=" & Form.HFiltro_Hnombre>
			<cfif isdefined('form.Hbloque') and LEN(TRIM(form.Hbloque))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Hbloque=" & Form.Hbloque>
			</cfif>
		</cfif>
		
		<cfinvoke 
		 component="edu.Componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaPlanEvalDet">
			<cfinvokeargument name="tabla"			value="HorarioTipo a, Horario b"/>
			<cfinvokeargument name="columnas" 		value="a.Hcodigo,b.Hbloque, 
															b.Hbloquenombre as NombreBloque, 
															str(b.Hentrada,5,2) as Entrada, 
															str(b.Hsalida,5,2) as Salida, 
															(case b.Htipo 
																when 1 then 'Clase' 
																when 2 then 'Recreo' 
																when 3 then 'Almuerzo' 
																when 4 then 'Actividad no curricular' 
																else 'No definido' end) as Tipo , '' as o,
															#form.Pagina# as Pagina,
															'#form.Filtro_Hnombre#' as Filtro_Hnombre,
															'#form.HFiltro_Hnombre#' as HFiltro_Hnombre"/>
			<cfinvokeargument name="desplegar" 		value="NombreBloque, Tipo, Entrada, Salida, o"/>
			<cfinvokeargument name="etiquetas" 		value="Bloque, Tipo, Hora Entrada, Hora Salida, "/>
			<cfinvokeargument name="formatos" 		value="S,S,V,V,U"/>
			<cfinvokeargument name="filtro" 		value=" a.CEcodigo = #Session.Edu.CEcodigo# and a.Hcodigo = #form.Hcodigo# and a.Hcodigo = b.Hcodigo order by a.Hcodigo"/>
			<cfinvokeargument name="filtrar_por" 	value="b.Hbloquenombre, (case b.Htipo when 1 then 'Clase' when 2 then 'Recreo' when 3 then 'Almuerzo' when 4 then 'Actividad no curricular' else 'No definido' end), b.Hentrada, b.Hsalida, ''"/>
			<cfinvokeargument name="align" 			value="left,left,right,right,left"/>
			<cfinvokeargument name="ajustar" 		value="N"/>,
			<cfinvokeargument name="irA" 			value="HorarioTipo.cfm"/>
			<cfinvokeargument name="formName" 		value="lista2"/>
			<cfinvokeargument name="PageIndex" 		value="2"/>
			<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
			<cfinvokeargument name="mostrar_filtro"	value="true"/>
			<cfinvokeargument name="filtrar_automatico"	value="true"/>
			<cfinvokeargument name="MaxRows"		value="#form.MaxRows#"/>
			<cfinvokeargument name="conexion" 		value="#session.Edu.DSN#">			
			<cfinvokeargument name="keys" 			value="Hcodigo,Hbloque"/>
		</cfinvoke>	
		<script language="javascript" type="text/javascript">
			function funcFiltrar2(){
				document.lista2.action = "HorarioTipo.cfm<cfoutput>?Hcodigo=#form.Hcodigo#<cfif isdefined('form.Hbloque')>&Hbloque=#form.Hbloque#</cfif>&Pagina=#Form.Pagina#&Filtro_Hnombre=#Form.Filtro_Hnombre#&HFiltro_Hnombre=#Form.HFiltro_Hnombre#</cfoutput>";
				return true;
            }
		</script>


	</cfif>
<cf_qforms>
<script language="JavaScript">
	function deshabilitarValidacion() {
		objForm.Hnombre.required = false;
		<cfif modo NEQ "ALTA">
		objForm.Hbloquenombre.required = false;
		</cfif>
	}
	
	function habilitarValidacion() {
		objForm.Hnombre.required = true;
		<cfif modo NEQ "ALTA">
		objForm.Hbloquenombre.required = true;
		</cfif>
	}	
		
	function funcCambio(){
		objForm.Hnombre.required = true;
		objForm.Hbloquenombre.required = false;
	}
	function funcNuevo(){
		deshabilitarValidacion();
	}
	function funcRegresar(){
		deshabilitarValidacion();
	}
	function funcAplicar(){
		deshabilitarValidacion();
		doConlisAplicaGradoAhorario();
		return false;
	}
	function funcBajaDet(){
		var mensaje = '';
		if(confirm('Desea eliminar el bloque?')){
			mensaje = valida(document.form1.Hbloquenombre,document.form1.HayHorarioGuiaDetalle.value,'bloque');
			if( mensaje != ''){
				alert(mensaje);
				return false;
			}
			deshabilitarValidacion();
			return true;
		}else{
			return false;
		}
	}
	
	function funcBaja(){
		var mensaje = '';
		if(confirm('Desea eliminar el Horario?')){
			mensaje = valida(document.form1.Hnombre,document.form1.HayHorarioGuia.value,'tipo de horario');
			if( mensaje != ''){
				alert(mensaje);
				return false;
			}
			deshabilitarValidacion();
			return true;
		}else{
			return false;
		}
	}
	function valida(dato,hayHorario,leyenda){
		var msg = "";
			
			if (new Number(hayHorario) > 0) {
				msg = msg + " Cursos "
			}
			if (msg != "")
			{	
				msg = 'No se puede eliminar el ' +  leyenda +' ' + dato.value + ' porque éste tiene asociado: ' + msg + '.';
				return(msg);
			}else{
				return '';
			}
	}
	objForm.Hnombre.required = true;
	objForm.Hnombre.description = "Descripción";	

	<cfif modo NEQ "ALTA">
		objForm.Hbloquenombre.required = true;
		objForm.Hbloquenombre.description = "Nombre del bloque";
	</cfif>

</script>