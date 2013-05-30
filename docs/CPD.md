### CPD (Copy-paste detector)

1. Open your Jenkins's job configuration
2. In **Build** section in **Execute Shell** field add command `cpd`, it should goes last, like that

		git checkout master
		git pull origin master
		builder
		cpd

3. In **Post-build Actions** section add 2 actions
	* Report Violations
	* Publish duplicate code analysis results
4. To configure them, write `cpd-output.xml` value into **Duplicate code results** field for _Publish duplicate code analysis results_. And the same value into very right field (XML filename pattern column) at `cpd` line for _Report Violations_.