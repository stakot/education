server_name=$(hostname)
function cpu_check() {
    echo "#######"
	echo "The current CPU load on ${server_name} is: "
    echo ""
	cat /proc/cpuinfo
    echo "#######"
}
cpu_check