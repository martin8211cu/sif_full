<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfquery name="rsPuesto" datasource="#session.DSN#">
	select RHPdescpuesto
	from RHPuestos
	where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#form.RHPcodigo#">
</cfquery>

<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar, SPid) as SPid, a.NPcodigo, b.NPdescripcion, a.RHPcodigo, c.RHPdescpuesto,  convert(varchar, SPfechaini, 103) as SPfechaini, convert(varchar, SPfechafin, 103) as SPfechafin, SPsalario, a.ts_rversion
		from SalarioPuesto a, NProfesional b, RHPuestos c
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
		  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and a.NPcodigo=b.NPcodigo
		  and a.Ecodigo=b.Ecodigo
		  and a.RHPcodigo=c.RHPcodigo
		  and a.Ecodigo=c.Ecodigo
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select NPcodigo, RHPcodigo, convert(varchar, SPfechaini, 103) as vSPfechaini, isnull(convert(varchar, SPfechafin, 103), '31/12/9999') as vSPfechafin
	from SalarioPuesto
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif modo neq 'ALTA'>
		and SPid!=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
	</cfif>
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	
	function validar(){
		document.form1.SPsalario.value = qf(document.form1.SPsalario);
		return true;
	}
	
	function fecha(valor){
		var sdate = valor.split("/");
		return new Date(sdate[2], sdate[1]-1, sdate[0] );
	}
	
	// crea un arreglo con los datos que existen en la bd, para validar las fechas seleccionadas
	var datos = new Array();
	
	var i = 0;
	<cfoutput query="rsCodigos">
		datos[i] = new Array('#trim(rsCodigos.NPcodigo)#', '#trim(rsCodigos.RHPcodigo)#', '#trim(rsCodigos.vSPfechaini)#', '#trim(rsCodigos.vSPfechafin)#');
		i++;
	</cfoutput>
</script>

<form name="form1" method="post" action="SQLSalarioPuesto.cfm" onSubmit="return validar();">
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		
		<tr> 
			<td align="right">Puesto:&nbsp;</td>
			<td>
				#rsPuesto.RHPdescpuesto#
				<input type="hidden" name="RHPcodigo" value="#form.RHPcodigo#">
			</td>
		</tr>

		<tr> 
			<td><div align="right">Nivel Profesional:&nbsp;</div></td>
			<td><cfif modo neq 'ALTA' ><cf_rhnivel query="#rsForm#" ><cfelse><cf_rhnivel></cfif></td>
		</tr>
		
		<tr>
			<td align="right">Fecha Inicial:&nbsp;</td>		
			<td>
				<cfif modo neq 'ALTA' ><cfset fechaini = rsForm.SPfechaini ><cfelse><cfset fechaini = "" ></cfif>
				<cf_sifcalendario form="form1" name="SPfechaini" value=#fechaini# >
			</td>	
		</tr>	
		
		<tr>	
			<td align="right">Fecha Final:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' ><cfset fechafin = rsForm.SPfechafin ><cfelse><cfset fechafin = "" ></cfif>
				<cf_sifcalendario form="form1" name="SPfechafin" value=#fechafin# >
			</td>	
		</tr>
		
		<tr>
			<td align="right">Salario:&nbsp;</td>
			<td><input name="SPsalario" type="text" style="text-align: right;" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript: fm(this,2); " onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.SPsalario, 'none')#<cfelse>0.00</cfif>" size="18" maxlength="14" ></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
		
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		
		<tr>
			<td>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
				<cfif modo neq "ALTA" >
					<input type="hidden" name="SPid" value="<cfif modo NEQ 'ALTA'>#rsForm.SPid#</cfif>">
				</cfif>	
			</td>
		</tr>
		
	</table>  
	</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	function existe(){
		var ufecha1  = "";
		var ufecha1  = "";
		var bdfecha1 = "";
		var bdfecha2 = ""

		objForm.NPcodigo.obj.value  = trim(objForm.NPcodigo.obj.value);
		objForm.RHPcodigo.obj.value = trim(objForm.RHPcodigo.obj.value);

		if ( (objForm.NPcodigo.obj.value != "") && (objForm.RHPcodigo.obj.value != "") ) {

			if (rango_fechas()){

				ufecha1  = fecha(objForm.SPfechaini.obj.value);	
				ufecha2  = (objForm.SPfechafin.obj.value != "") ? fecha(objForm.SPfechafin.obj.value) : fecha('31/12/9999');	
	
				for ( var i=0; i<=datos.length-1; i++){
					if ( (datos[i][0].toUpperCase()==objForm.NPcodigo.obj.value.toUpperCase()) && (datos[i][1].toUpperCase()==objForm.RHPcodigo.obj.value.toUpperCase()) ) {
						bdfecha1 = fecha(datos[i][2]);	
						bdfecha2 = (datos[i][3] != "") ? fecha(datos[i][3]) : "";
	
						// Caso 1: la fecha inicial cae en un rango de fechas ya establecido
						if ( ( ufecha1 >= bdfecha1 ) && ( ufecha1 <= bdfecha2 ) ) {
							this.error = "Rango de fechas invalido.";
							break;
						}// if caso 1
	
						// Caso 2: la fecha final cae en un rango de fechas ya establecido
						if ( ( ufecha2 >= bdfecha1 ) && ( ufecha2 <= bdfecha2 ) ) {
							this.error = "Rango de fechas invalido.";
							break;
						}// if caso 2
		
						// Caso 3: la fecha final que quiero insertar contiene un rango de fechas ya definido
						// Ej: en bd tenemos 01/01/2003 - 01/02/2003, y quiero meter 31/12/2002 - 31/12/2003 
						// la fecha que ya existe, esta contenida en el rango que quiero insertar, no se permite.
						if ( ( ufecha1 <= bdfecha1 ) && ( ufecha2 >= bdfecha2 ) ) {
							this.error = "Rango de fechas invalido.";
							break;
						}// if caso 3
	
						// Caso 4: es el siguiente caso: en la bd tenemos 01/01/2003 - infinito
						// el usuario quiere insertar 01/01/2002 - infinito, esto no se permite, pues incluye a una fecha ya establecida
						if ( ( ufecha1 <= bdfecha1 ) && ( ufecha2==bdfecha2 ) ) {
							this.error = "Rango de fechas invalido.";
							break;
						} // caso 4	
					} // if (vacios)
				} // for
			}// rango_fechas
			else{
				this.error = "Rango de fechas invalido.";
			}	
		} // blancos
	}// existe
	_addValidator("isExiste", existe);
	
	function rango_fechas(){
		objForm.SPfechaini.obj.value = trim(objForm.SPfechaini.obj.value);
		objForm.SPfechafin.obj.value = trim(objForm.SPfechafin.obj.value);

		if ( (objForm.SPfechaini.obj.value != "") && (objForm.SPfechafin.obj.value != "") ) {
			var date1 = fecha(objForm.SPfechaini.obj.value);
			var date2 = fecha(objForm.SPfechafin.obj.value);
			
			if ( date1 > date2 ){
				return false;
			}
			else{
				return true;
			}	
		}
		return true;
	}
	
	objForm.NPcodigo.required = true;
	objForm.NPcodigo.description="Nivel Profesional";

	objForm.SPfechaini.required = true;
	objForm.SPfechaini.description="Fecha Inicial";

	objForm.SPsalario.required = true;
	objForm.SPsalario.description="Salario";
	
	objForm.SPfechaini.validateExiste();
	
</script>