<cfset def = QueryNew('dato')>

<cfparam name="Attributes.TipoId" default="" type="string"> <!--- Indica si el Tipo de Identificación que se va a manejar, cuando no se indica se coloca un combo --->
<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Empleados --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" default="FRempleado" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Empleado --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.conlis" default="true" 			type="boolean"> <!--- muestra conlis o no --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Len(Trim(Attributes.TipoId)) EQ 0>
	<cfquery name="rsTipoId" datasource="#Session.DSN#">
		select NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara
		from NTipoIdentificacion	
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlisEmpleados<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		var evaluacion = document.<cfoutput>#Attributes.form#</cfoutput>.RHEEid;
		if (evaluacion.value != '' ){
			<cfoutput>
				<cfif Attributes.TipoId EQ "-1">
						var nuevo = window.open('/cfmx/rh/evaluaciondes/consultas/ConlisEmpleadosCap.cfm?f=#Attributes.form#&p1=DEid#index#&p2=NTIcodigo#index#&p3=DEidentificacion#index#&p4=NombreEmp#index#&filtro='+evaluacion.value,'ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
				<cfelse>
						var nuevo = window.open('/cfmx/rh/evaluaciondes/consultas/ConlisEmpleadosCap.cfm?NTIcodigo='+document.#Attributes.form#.NTIcodigo#index#.value+'&f=#Attributes.form#&p1=DEid#index#&p2=NTIcodigo#index#&p3=DEidentificacion#index#&p4=NombreEmp#index#&filtro='+evaluacion.value,'ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
				</cfif>
			</cfoutput>
			nuevo.focus();
		}
		else{
			alert('Debe seleccionar la Evaluación.');
		}	
	}
	
	function ResetEmployee<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.DEid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.DEidentificacion#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.NombreEmp#index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeEmpleado<cfoutput>#index#</cfoutput>(TipoId, Ident) {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.DEid<cfoutput>#index#</cfoutput>;
		window.ctlident = document.<cfoutput>#Attributes.form#</cfoutput>.DEidentificacion<cfoutput>#index#</cfoutput>;
		window.ctlemp = document.<cfoutput>#Attributes.form#</cfoutput>.NombreEmp<cfoutput>#index#</cfoutput>;
		
		var evaluacion = document.<cfoutput>#Attributes.form#</cfoutput>.RHEEid;
		if (evaluacion.value != '' ){
			if (document.<cfoutput>#Attributes.form#.DEidentificacion#index#</cfoutput>.value != "") {
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/rh/evaluaciondes/consultas/rhempleadocapquery.cfm?NTIcodigo="+TipoId+"&DEidentificacion="+Ident+"&filtro="+evaluacion.value;
			} else {
				ResetEmployee<cfoutput>#index#</cfoutput>();
				if (window.funcDEid) funcDEid();
			}
			return true;
		}
		else{
			alert('Debe seleccionar la Evaluación.');
		}	
	}

<cfif Len(Trim(Attributes.TipoId)) EQ 0>
	var tipomask = new Object();
	<cfloop query="rsTipoId">
		tipomask['<cfoutput>#rsTipoId.NTIcodigo#</cfoutput>'] = '<cfoutput>#rsTipoId.NTImascara#</cfoutput>';
	</cfloop>
</cfif>

</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<cfif Len(Trim(Attributes.TipoId)) EQ 0>
			<select name="NTIcodigo#index#" id="NTicodigo#index#" onChange="javascript: ResetEmployee#index#();" <cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
			<cfloop query="rsTipoId">
				<option value="#rsTipoId.NTIcodigo#" <cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#") and rsTipoId.NTIcodigo eq Evaluate("Attributes.query.NTIcodigo#index#")>selected</cfif>>#rsTipoId.NTIdescripcion#</option>
			</cfloop>
			</select>
		<cfelse>
			<input type="hidden" name="NTIcodigo#index#" id="NTicodigo#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.NTIcodigo#index#")>#Evaluate("Attributes.query.NTIcodigo#index#")#<cfelse>#Attributes.TipoId#</cfif>">
		</cfif>
		</td>
		<td>
			<input type="hidden" name="DEid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.DEid#index#")>#Evaluate("Attributes.query.DEid#index#")#</cfif>">
			<input type="text"
				name="DEidentificacion#index#" id="DEidentificacion#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.DEidentificacion#index#")>#Evaluate("Attributes.query.DEidentificacion#index#")#</cfif>"
				onblur="javascript: TraeEmpleado#index#(document.#Attributes.form#.NTIcodigo#index#.value,document.#Attributes.form#.DEidentificacion#index#.value);"
				<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>>
		</td>
	    <td nowrap>
			<input type="text"
				name="NombreEmp#index#" id="NombreEmp#index#"
				tabindex="-1"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.NombreEmp#index#")>#Evaluate("Attributes.query.NombreEmp#index#")#</cfif>" 
				maxlength="80"
				size="#Attributes.size#"
				readonly='true'>
			<cfif Attributes.Conlis><a href="javascript: doConlisEmpleados#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
		</td>
	</tr>
</table>
</cfoutput>

<cfif not isdefined("Request.EmployeeTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility:hidden;"></iframe>
	<cfset Request.EmployeeTag = True>
</cfif>
