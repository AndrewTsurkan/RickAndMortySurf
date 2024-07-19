protocol MainScreenView: AnyObject {
    func updateData(data: [ResponseResult])
    func updateTableView()
}
