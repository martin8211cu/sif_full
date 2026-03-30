<!---

Agrega o elimina usuarios del archivo policy.txt, que
a su vez contiene la lista de usuarios excluidos del sistema de roaming de ipass

El formato de la línea guardada en el archivo de ipass está codificado
en los shell scrips adjuntos.

Requiere de los siguiente scripts instalados en el servidor en el directorio 
indicado por commandPath. Por favor refleje en este archivo cualquier cambio
que realice a los scripts.

cat > saci-add.sh
#!/bin/bash
# Agrega un usuario al policy.txt
# regresa 1 si ya existe, y 0 si no existe
if [ $# -ne 2 ]; then
	echo "Usage: $(dirname $0) policyFile username"
fi
file=$1; uid=$2
# Completar a 17 chars
while [ ${#uid} -lt 17 ]; do uid="${uid} "; done
sp1="*                  "
grep -w ${uid} ${file} > /dev/null && exit 1
echo -e "${sp1}"\\t${uid}\\t"${sp1}"\\tN >> $file

cat > saci-rm.sh
#!/bin/bash
# Elimina un usuario del policy.txt
# regresa 1 si no existe, y 0 si ya existe
if [ $# -ne 2 ]; then
	echo "Usage: $(dirname $0) policyFile username"
fi
file=$1; uid=$2
# Completar a 17 chars
while [ ${#uid} -lt 17 ]; do uid="${uid} "; done
sp1="*                  "
grep -w ${uid} ${file} > /dev/null || exit 1
mv ${file} ${file}.bak
grep -v -w ${uid} ${file}.bak > ${file}

chmod 500 saci-*.sh
--->
<cfcomponent output="no" extends="ShellService">

	<cfset This.Enabled = getParametro(540) is 1>
	<cfset This.commandPath = getParametro(541)>
	<cfset This.policyFile = getParametro(542)>
	<cfset This.modoShell = getParametro(550)>
	
	<cffunction name="agregarLoginIpass" output="false" returntype="numeric" hint="Añade el usuario al archivo de restricciones policy.txt.  Regresa 0 si OK, otro si es error">
		<cfargument name="Usuario" type="string" required="yes">
		<cfif Not This.Enabled><cfreturn 0></cfif>
		<cfset control_mensaje( 'IPA-0001', 'usuario=#Arguments.usuario#' )>
		<!--- se usa comilla simple y doble para escapar del shell de windows y del ssh --->
		<cfset cmd = This.commandPath & "saci-add.sh " & This.policyFile
				& " " & (Arguments.Usuario)>
		<cfset control_mensaje( 'IPA-0003', '#cmd#' )>
		<cfreturn shellExecute(cmd,'ipass','saci-add.sh')>
	</cffunction>
	
	<cffunction name="borrarLoginIpass" output="false" returntype="numeric" hint="Borra el usuario del archivo de restricciones policy.txt.  Regresa 0 si OK, otro si es error">
		<cfargument name="Usuario" type="string" required="yes">
		<cfif Not This.Enabled><cfreturn 0></cfif>
		<cfset control_mensaje( 'IPA-0001', 'usuario=#Arguments.usuario#' )>
		<cfset cmd = This.commandPath & "saci-rm.sh " & This.policyFile
				& " " & (Arguments.Usuario)>
		<cfset control_mensaje( 'IPA-0003', '#cmd#' )>
		<cfreturn shellExecute(cmd,'ipass','saci-rm.sh')>
	</cffunction>
</cfcomponent>