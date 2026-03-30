<cfsilent>
<!--- TAG inputTime: ESTE TAG PERMITE CAPTURAR UNA HORA EN UN FORMATO 
FIJO HH:mm = 24 horas (formato militar) --->
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<cfset def = QueryNew('Time')>
<cfparam name="Attributes.form" default="form1"> <!--- Nombre del Formulario que contiene el objeto --->
<cfparam name="Attributes.name" default="time1"> <!--- Nombre del Objeto --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- Query con valor del Campo --->
<cfparam name="Attributes.value" default="" type="string"> <!--- Valor del Objeto --->
<cfparam name="Attributes.default" default="00:00" type="string"> <!--- Valor por Defcto del Objeto si no tiene Query o Value del Objeto --->
<cfparam name="Attributes.tabindex" default="-1" type="numeric"> <!--- TabIndex del Objeto --->
<cfscript>
	Lvar_Sufix=Attributes.form&"_"&Attributes.name;
	Lvar_FunctionName="fn_"&Lvar_Sufix;
	Lvar_Value="00:00";
	if (isdefined("query.#Attributes.name#") and len(trim(Evaluate("query.#Attributes.name#"))) gt 0) {
		Lvar_Value=Evaluate("query.#Attributes.name#");
	} else if (len(trim(Attributes.value))) {
		Lvar_Value=Attributes.value;
	} else {
		Lvar_Value=Attributes.default;
	}
</cfscript>
</cfsilent>
<cfoutput>
<input type="text" name="#Attributes.name#" id ="#Attributes.name#"
	<cfif Attributes.tabIndex gt 0>tabIndex="#Attributes.tabIndex#"</cfif>
	size="5" maxlength="5" value="" 
	onFocus="javascript:this.select();" 
	onClick="javascript:this.select();">
<cfparam name="Request.jsMask" default="false">
<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script src="/js/MaskApi/masks.js"></script>
</cfif>
<cfparam name="Request.jsInputTime" default="false">
<cfif Request.jsInputTime EQ false>
	<cfset Request.jsInputTime = true>
	<script language="javascript" type="text/javascript">
		function onChangeInputTime(o,d) {
			if (o.value.length==0) {
				o.value=d;
			} else if (o.value.length==1) {
				o.value="0"+o.value+":00";
			} else if (o.value.length==2) {
				o.value+=":00";
			} else if (o.value.length==4) {
				o.value+="0";
			}
			var nHH = parseFloat(o.value.substring(0,2));
			var nmm = parseFloat(o.value.substring(3,5));
			if (nHH > 23) {
				alert("El Formato de la Hora es Incorrecto");
				return false;
			}
			if (nmm > 59) {
				alert("El Formato de los Minutos es Incorrecto");
				return false;
			}
			return true;
		}
	</script>
</cfif>
<script language="javascript" type="text/javascript">
  oStringMaskTime = new Mask("####:####");
  oStringMaskTime.attach(document.#Attributes.form#.#Attributes.name#,"####:####","numeric","return onChangeInputTime(this,'#Lvar_Value#');");
  document.#Attributes.form#.#Attributes.name#.value="#Lvar_Value#";
</script>
</cfoutput>