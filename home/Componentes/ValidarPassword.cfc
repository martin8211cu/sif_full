<cfcomponent >
<cffunction name="javascript" output="true">
<cfargument name="data" type="struct">
<cfoutput>
<script type="text/javascript">
<cfif data.pass.valida.usuario is 1>
<!--- Validacion de la contrasenia (lado del cliente)
// distancia minima entre dos hileras, se usa para validar el password
// http://www.csse.monash.edu.au/~lloyd/tildeAlgDS/Dynamic/Edit.html --->
function DPA(s1, s2){
	var m = new Array();
	var i, j;
	for(i=0; i < s1.length + 1; i++) m[i] = new Array(); <!--- i.e. 2-D array --->

	m[0][0] = 0;<!--- boundary conditions --->

	for(j=1; j <= s2.length; j++)
		m[0][j] = m[0][j-1]-0 + 1; <!--- boundary conditions --->

	for(i=1; i <= s1.length; i++) <!--- outer loop --->
	{
		m[i][0] = m[i-1][0]-0 + 1; <!--- boundary conditions --->

		for(j=1; j <= s2.length; j++)                         <!--- inner loop --->
		{
			var diag = m[i-1][j-1];
			if( s1.charAt(i-1) != s2.charAt(j-1) ) diag++;

			m[i][j] = Math.min( diag,               <!--- match or change --->
				Math.min( m[i-1][j]-0 + 1,    <!--- deletion --->
				m[i][j-1]-0 + 1 ) ) <!--- insertion --->
		}<!--- for j --->
	}<!--- for i --->

	return m[s1.length][s2.length];
 }<!--- DPA --->
</cfif>
function letrasNumerosSimbolos (s)
{
	var letras = <cfif data.pass.valida.letras is 1>false<cfelse>true</cfif>,
		numeros = <cfif data.pass.valida.digitos is 1>false<cfelse>true</cfif>,
		simbolos = <cfif data.pass.valida.simbolos is 1>false<cfelse>true</cfif>,
		i, ch, esLetra, esNumero;
	for (i = 0; i < s.length; i++) {
		ch = s.charAt(i);
		letras  |= ( esLetra = (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') );
		numeros |= ( esNumero = (ch >= '0' && ch <= '9') );
		simbolos |= ( !esLetra && !esNumero );
		if (letras && numeros && simbolos) return true;
	}
	return false;
}
function Simbolos (s)
{
	var letras = <cfif data.pass.valida.letras is 1>false<cfelse>true</cfif>,
		numeros = <cfif data.pass.valida.digitos is 1>false<cfelse>true</cfif>,
		simbolos = <cfif data.pass.valida.simbolos is 1>false<cfelse>true</cfif>,
		i, ch, esLetra, esNumero;
	for (i = 0; i < s.length; i++) {
		ch = s.charAt(i);
		letras  |= ( esLetra = (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') );
		numeros |= ( esNumero = (ch >= '0' && ch <= '9') );
		simbolos |= ( !esLetra && !esNumero );
		if (simbolos) return true;
	}
	return false;
}
function letrasMayusculas (s){
	var letras = <cfif data.pass.valida.letras is 1>false<cfelse>true</cfif>,i, ch, esLetra;
	for (i = 0; i < s.length; i++) {
		ch = s.charAt(i);
		letras  |= ( esLetra = (ch >= 'A' && ch <= 'Z'));
		if (letras ) return true;
	}
	return false;
}
function Numeros (s){
	var numeros = <cfif data.pass.valida.digitos is 1>false<cfelse>true</cfif>,i, ch, esNumero;
	for (i = 0; i < s.length; i++) {
		ch = s.charAt(i);
		numeros |= ( esNumero = (ch >= '0' && ch <= '9') );
		if (numeros ) return true;
	}
	return false;
}

// regresa un array con los errores encontrados, o un array vacío si no hay errores.
function validarPassword (user, pass)
{
	var retval = {erruser:new Array(), errpass: new Array()};
	if (user.length < #data.user.long.min#) {
		retval.erruser.push ( "El usuario debe medir al menos #data.user.long.min# caracteres." );
	}
	if (user.length > #data.user.long.max#) {
		retval.erruser.push ( "El usuario debe medir como máximo #data.user.long.max# caracteres." );
	}
	if (pass.length < #data.pass.long.min#) {
		retval.errpass.push ( "La contrase\u00f1a debe medir al menos #data.pass.long.min# caracteres." );
	}
	if (pass.length > #data.pass.long.max#) {
		retval.errpass.push ( "La contrase\u00f1a debe medir como máximo #data.pass.long.max# caracteres." );
	}
	<cfif data.pass.valida.digitos is 1>
	if (!Numeros (pass)) {
		retval.errpass.push ( "La contrase\u00f1a debe contener al menos un Numero." );
	}
	</cfif>
	<cfif data.pass.valida.letras is 1>
	if (!letrasMayusculas (pass)) {
		retval.errpass.push ( "La contrase\u00f1a debe contener al menos una Mayúscula." );
	}
	</cfif>
	<cfif isdefined('data.user.valida.digitos') and data.user.valida.digitos is 1>
	if (!Numeros (user)) {
		retval.erruser.push ( "El usuario debe contener al menos un Numero." );
	}
	</cfif>
	<cfif isdefined('data.user.valida.letras') and data.user.valida.letras is 1>
	if (!letrasMayusculas (user)) {
		retval.erruser.push ( "El usuario debe contener al menos una Mayúscula." );
	}
	</cfif>

	<cfif data.pass.valida.simbolos is 1>
	if (!Simbolos (pass)) {
		retval.errpass.push ( "La contrase\u00f1a debe contener Simbolos." );
	}
	</cfif>


	<cfif data.pass.valida.usuario is 1>
	if (user == pass) {
		retval.errpass.push ( "La contrase\u00f1a no puede coincidir con el login de usuario." );
	} else if (user.indexOf(pass) != -1) {
		retval.errpass.push ( "La contrase\u00f1a no puede ser parte del login de usuario." );
	} else if (user.length && pass.indexOf(user) != -1) {
		retval.errpass.push ( "La contrase\u00f1a no debe contener el login de usuario." );
	} else if (DPA(user.toUpperCase(),pass.toUpperCase()) < 6) {
		retval.errpass.push ( "La contrase\u00f1a no debe tener relacion con el login de usuario."+DPA(user.toUpperCase(),pass.toUpperCase()) );
	} else{}

	</cfif>
	<cfif Len(data.user.valid.chars)>
	if (! (/^[#data.user.valid.chars#]*$/.test(user))) {
		retval.erruser.push ( "Los caracteres permitidos para el usuario son: \"#data.user.valid.chars#\"." );
	}
	if (! (/^[#data.user.valid.chars#]*$/.test(pass))) {
		retval.errpass.push ( "Los caracteres permitidos para la contrase\u00f1a son: \"#data.user.valid.chars#\"." );
	}
	</cfif>
	return retval;
}

</script>
</cfoutput>
</cffunction>

<cffunction name="validar" output="false" returntype="struct">
	<cfargument name="data" type="struct">
	<cfargument name="user">
	<cfargument name="pass">

	<cfscript>

	var retval = StructNew();
	retval.erruser = ArrayNew(1);
	retval.errpass = ArrayNew(1);

	if (Len(user) LT data.user.long.min) {
		ArrayAppend(retval.erruser, "El usuario debe medir al menos #data.user.long.min# caracteres." );
	}
	if (Len(user) GT data.user.long.max) {
		ArrayAppend(retval.erruser, "El usuario debe medir como máximo #data.user.long.min# caracteres." );
	}
	if (Len(pass) LT data.pass.long.min) {
		ArrayAppend(retval.errpass, "La contraseña debe medir al menos #data.pass.long.min# caracteres." );
	}
	if (Len(pass) GT data.pass.long.max) {
		ArrayAppend(retval.errpass, "La contraseña debe medir como máximo #data.pass.long.min# caracteres." );
	}
	if (data.pass.valida.digitos is 1){
		if (Not Numeros(data, pass)) {
		ArrayAppend(retval.errpass , "La contraseña debe contener al menos un Numero." );
		}
	}
	if ( data.pass.valida.letras is 1){
		if (Not letrasMayusculas(data, pass)) {
		ArrayAppend(retval.errpass ,  "La contraseña debe contener al menos una Mayúscula." );
		}
	}
	/*if ( data.user.valida.digitos is 1){
		if (Not Numeros(data, user)) {
		ArrayAppend(retval.erruser , "El usuario debe contener al menos un Numero." );
		}
	}
	if ( data.user.valida.letras is 1){
		if (Not letrasMayusculas(data, user)) {
		ArrayAppend(retval.erruser , "El usuario debe contener al menos una Mayúscula." );
		}
	}*/
	if ( data.pass.valida.simbolos is 1){
		if (Not Simbolos (data, pass)) {
		ArrayAppend(retval.errpass , "La contraseña debe contener Simbolos." );
		}
	}
	if (data.pass.valida.usuario is 1) {
		if (user EQ pass) {
			ArrayAppend(retval.errpass, "La contraseña no puede coincidir con el login de usuario." );
		} else if (Find(pass, user)) {
			ArrayAppend(retval.errpass, "La contraseña no puede ser parte del login de usuario." );
		} else if (Len(pass) And Find(user,pass)) {
			ArrayAppend(retval.errpass, "La contraseña no debe contener el login de usuario." );
		} else if (DPA(user,pass) LT 6) {
			ArrayAppend(retval.errpass, "La contraseña no debe tener relacion con el login de usuario." );
		}
	}
	if (Len(data.user.valid.chars)) {
		if (Not REFind("^[" & data.user.valid.chars & "]*$", user)) {
			ArrayAppend(retval.erruser, "Los caracteres permitidos para el usuario son: ""#data.user.valid.chars#""." );
		}
		if (Not REFind("^[" & data.user.valid.chars & "]*$", pass)) {
			ArrayAppend(retval.errpass, "Los caracteres permitidos para la contraseña son: ""#data.user.valid.chars#""." );
		}
	}
	</cfscript>

	<cfif data.pass.valida.diccionario>
		<cfquery datasource="asp" name="diccionario">
			select 1 from PalabrasComunes
			where palabra = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(pass)#">
		</cfquery>
		<cfif diccionario.RecordCount>
			<cfset ArrayAppend(retval.errpass, "La contraseña seleccionada es muy común.")>
		</cfif>
	</cfif>

	<cfreturn retval>
</cffunction>

<cffunction name="DPA" output="false">
	<cfargument name="s1" type="string">
	<cfargument name="s2" type="string">
	<cfscript>
		var m = ArrayNew(2); // s1.len+1 x s2.len+1 === i x j
		var i=0;
		var j=0;
		var diag=0;

		//for(i=0; i LT s1.length + 1; i=i+1) m[i] = ArrayNew(1); // i.e. 2-D array

		m[1][1] = 0; // boundary conditions

		for(j=1; j LE Len(s2); j=j+1)
			m[1][j+1] = m[1][j]-0 + 1; // boundary conditions

		for(i=1; i LE Len(s1); i=i+1) // outer loop
		{
			m[i+1][1] = m[i][1]-0 + 1; // boundary conditions

			for(j=1; j LE Len(s2); j=j+1)                         // inner loop
			{
				diag = m[i][j];
				if( Mid(s1,i,1) NEQ Mid(s2,j,1) ) diag=diag+1;

				m[i+1][j+1] = Min( diag, Min( m[i][j+1]-0 + 1, m[i+1][j]-0 + 1 ) );
			}// for j
		}// for i

		return m[Len(s1)+1][Len(s2)+1];
	</cfscript>
</cffunction><!--- DPA --->
<cffunction name="Simbolos" returntype="boolean">
	<cfargument name="data" type="struct">
	<cfargument name="s" type="string">
	<cfscript>
		var letras   = data.pass.valida.letras neq 1;
		var numeros  = data.pass.valida.digitos neq 1;
		var simbolos = data.pass.valida.simbolos neq 1;
		var i=0;
		var ch='x';
		var esLetra=false;
		var esNumero=false;
		//	WriteOutput('i:' & i & ',ch:' & ch & ',esLetra:' & esLetra & ',esNumero:' & esNumero & ',letras:' & letras & ',numeros' & numeros & ',simbolos:' & simbolos & '<br>');
		for (i = 1; i LE Len(s); i=i+1) {
			ch = Mid(s,i,1);
			esLetra = (ch GE 'A' And ch LE 'Z') OR (ch GE 'a' And ch LE 'z');
			esNumero = (ch GE '0' And ch LE '9');

			letras  = letras or esLetra;
			numeros = numeros or esNumero ;
			simbolos = simbolos or ( (not esLetra) and (not esNumero) );
			WriteOutput('i:' & i & ',ch:' & ch & ',esLetra:' & esLetra & ',esNumero:' & esNumero & ',letras:' & letras & ',numeros' & numeros & ',simbolos:' & simbolos & '<br>');
			if (simbolos) return true;
		}
		return false;
	</cfscript>
</cffunction>

<cffunction name="letrasMayusculas" returntype="boolean">
	<cfargument name="data" type="struct">
	<cfargument name="s" type="string">
	<cfscript>
		var letras = data.pass.valida.letras neq 1;
		var i=0;
		var ch='x';
		var esLetra=false;
		for (i = 1; i LE Len(s); i=i+1) {
			ch = Mid(s,i,1);
			if(ch >= 'A' and ch <= 'Z'){
				esLetra = true;
			}
			WriteOutput('i:' & i & ',ch:' & ch & ',esLetra:' & esLetra & ',letras:' & letras & '<br>');
			if (esLetra ) return true;
		}
		return false;
	</cfscript>
</cffunction>
<cffunction name="Numeros" returntype="boolean">
	<cfargument name="data" type="struct">
	<cfargument name="s" type="string">
	<cfscript>
		var numeros = data.pass.valida.digitos neq 1;
		var i=0;
		var ch='x';
		var esNumero=false;
		for (i = 1; i LE Len(s); i=i+1) {
			ch = Mid(s,i,1);
			esNumero = (ch GE '0' And ch LE '9');

			WriteOutput('i:' & i & ',ch:' & ch & ',esNumero:' & esNumero & ',numeros' & numeros & '<br>');
			if (esNumero) return true;
		}
		return false;
	</cfscript>
</cffunction>
<cffunction name="letrasNumerosSimbolos" returntype="boolean">
	<cfargument name="data" type="struct">
	<cfargument name="s" type="string">
	<cfscript>
		var letras = data.pass.valida.letras neq 1;
		var i=0;
		var ch='x';
		var esLetra=false;
		var esNumero=false;
		//	WriteOutput('i:' & i & ',ch:' & ch & ',esLetra:' & esLetra & ',esNumero:' & esNumero & ',letras:' & letras & ',numeros' & numeros & ',simbolos:' & simbolos & '<br>');
		for (i = 1; i LE Len(s); i=i+1) {
			ch = Mid(s,i,1);
			esLetra = (ch GE 'A' And ch LE 'Z') OR (ch GE 'a' And ch LE 'z');
			esNumero = (ch GE '0' And ch LE '9');

			letras  = letras or esLetra;
			numeros = numeros or esNumero ;
			simbolos = simbolos or ( (not esLetra) and (not esNumero) );
			WriteOutput('i:' & i & ',ch:' & ch & ',esLetra:' & esLetra & ',esNumero:' & esNumero & ',letras:' & letras & ',numeros' & numeros & ',simbolos:' & simbolos & '<br>');
			if (letras And numeros And simbolos) return true;
		}
		return false;
	</cfscript>
</cffunction>

<cffunction name="reglas" output="false" returntype="struct">
	<cfargument name="data" type="struct">

    <cfset LvarIdioma = 'es'>
    <cfif isdefined("session.idioma")>
    	<cfset LvarIdioma = session.idioma>
    </cfif>

	<cfset t = createobject("component","sif.Componentes.Translate")>
    <cfset LB_ElUsuariDebeMedirEntre = t.translate('LB_ElUsuariDebeMedirEntre','El usuario debe medir entre','/rh/generales.xml',LvarIdioma)>
    <cfset LB_LaContrasennaDebeMedirEntre = t.translate('LB_LaContrasennaDebeMedirEntre','La contraseña debe medir entre','/rh/generales.xml',LvarIdioma)>
    <cfset LB_Y = t.translate('LB_Y','y','/rh/generales.xml',LvarIdioma)>
    <cfset LB_Caracteres = t.translate('LB_Caracteres','caracteres','/rh/generales.xml',LvarIdioma)>
    <cfset LB_LaContrasenaDebeContenerAlMenosUnNumero = t.translate('LB_LaContrasenaDebeContenerAlMenosUnNumero','La contraseña debe contener al menos un Número','/rh/generales.xml',LvarIdioma)>
    <cfset LB_LosCaracteresPermitidosParaLaContrasena = t.translate('LB_LosCaracteresPermitidosParaLaContrasenaSon','Los caracteres permitidos para la contraseña son','/rh/generales.xml',LvarIdioma)>
    <cfset LB_LaContrasenaNoPuedeCoincidirConElUsuarioNiSimilar = t.translate('LB_LaContrasenaNoPuedeCoincidirConElUsuarioNiSimilar','La contraseña no puede coincidir con el usuario, ni ser similar al mismo','/rh/generales.xml',LvarIdioma)>


	<cfscript>

	retval = StructNew();
	retval.erruser = ArrayNew(1);
	retval.errpass = ArrayNew(1);

	ArrayAppend(retval.erruser, "#LB_ElUsuariDebeMedirEntre# #data.user.long.min# #LB_Y# #data.user.long.max# #LB_Caracteres#." );
	ArrayAppend(retval.errpass, "#LB_LaContrasennaDebeMedirEntre# #data.pass.long.min# #LB_Y# #data.pass.long.max# #LB_Caracteres#." );

	if (data.pass.valida.simbolos) {
		ArrayAppend(retval.errpass, "La contraseña debe contener Simbolos." );
	}
	if (data.pass.valida.letras) {
		ArrayAppend(retval.errpass, "La contraseña debe contener al menos una Mayúscula." );
	}
	if (data.pass.valida.digitos) {
		ArrayAppend(retval.errpass, "#LB_LaContrasenaDebeContenerAlMenosUnNumero#." );
	}
	if (structKeyExists(data,"user.valida.letras")) {
		if (data.user.valida.letras) {
			ArrayAppend(retval.erruser, "El usuario debe contener al menos una Mayúscula." );
		}
	}
	if (structKeyExists(data,"user.valida.digitos")) {
		if (data.user.valida.digitos) {
			ArrayAppend(retval.erruser, "El usuario debe contener al menos un Número." );
		}
	}
	if (data.pass.valida.usuario is 1) {
		ArrayAppend(retval.errpass, "#LB_LaContrasenaNoPuedeCoincidirConElUsuarioNiSimilar#." );
	}
	if (Len(data.user.valid.chars)) {
		ArrayAppend(retval.erruser, "Los caracteres permitidos para el usuario son: ""#data.user.valid.chars#""." );
		ArrayAppend(retval.errpass, "#LB_LosCaracteresPermitidosParaLaContrasena#: ""#data.user.valid.chars#""." );
	}
	if (data.pass.valida.diccionario) {
		ArrayAppend(retval.errpass, "La contraseña no puede aparecer en el diccionario.");
	}
	if (data.pass.valida.lista gt 0) {
		ArrayAppend(retval.errpass, "La contraseña no puede ser igual a la(s) #data.pass.valida.lista# anteriores.");
	}


	</cfscript>

	<cfreturn retval>

</cffunction>

</cfcomponent>