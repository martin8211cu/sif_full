

<cfinvoke returnvariable="rs_Res" component="sif.ep.componentes.EP_EstrSaldosPr" method="CG_EstructuraSaldo"
		IDEstrPro="3"
		PerInicio="2013"
		MesInicio="1"
		PerFin="2013"
		MesFin="1"
		MonedaLoc="True"
		Gvarconexion = 'sifcim2'
        PerIniPP="2013"
        MesIniPP="01">
		>
		
		<!---<cfinvokeargument name="IDEstrPro" value="1"/>
		<cfinvokeargument name="PerInicio" value="2012"/>
		<cfinvokeargument name="MesInicio" value="8"/>
		<cfinvokeargument name="PerFin" value="2012"/>
		<cfinvokeargument name="MesFin" value="9"/>
		<cfinvokeargument name="MonedaLoc" value="true"/>
<!---	--->	Miso4217="#LvarIncluirOficina#">--->

</cfinvoke>	

<cf_dumptofile select="select * from #rs_Res# order by PCDvalor">
<!---<cf_dumptofile select="select sum(SLinicial), sum(SLDebito), sum(SLCredito) from #rs_Res# group by ID_EstrCtaVal">--->