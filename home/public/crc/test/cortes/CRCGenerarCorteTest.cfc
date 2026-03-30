<cfcomponent output="false" displayname="CRCGenerarCorteTest" hint="pruebas unitarias para generación de cierres de cortes" extends="home.public.crc.test.TestComponentBase">


	<cffunction name="generarCorte" access="remote" returntype="void" hint="ejecuta el proceso de generacion de corte ">

			<cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").init(Ecodigo=1)>

			<cfset CRCProcesoCorte.procesarCorte()>

    </cffunction>		

</cfcomponent>