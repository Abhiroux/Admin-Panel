package model;

public class Employee {
    private String name;
    private String position;
    private String join_date;

    public Employee(String name, String position, String join_date) {
        this.name = name;
        this.position = position;
        this.join_date = join_date;
    }

    public String getName() {
        return name;
    }

    public String getPosition() {
        return position;
    }

    public String getJoinDate() {
        return join_date;
    }
}
